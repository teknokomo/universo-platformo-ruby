# SupabaseAuthService - Handles authentication via Supabase REST API
#
# Uses the Supabase Auth API (https://supabase.com/docs/reference/javascript/auth-api)
# to authenticate users through the backend. Credentials are never exposed to the client.
#
# Configuration:
#   SUPABASE_URL - Your Supabase project URL
#   SUPABASE_KEY - Your Supabase anon key (for public operations)
#   SUPABASE_SERVICE_KEY - Your Supabase service role key (for admin operations)
require 'net/http'
require 'json'
require 'uri'

class SupabaseAuthService
  SUPABASE_URL = ENV.fetch('SUPABASE_URL', nil)
  SUPABASE_KEY = ENV.fetch('SUPABASE_KEY', nil)

  # Sign in with email and password
  #
  # @param email [String] User's email address
  # @param password [String] User's password
  # @return [Hash] Result with :success, :user, :access_token, or :error
  def self.sign_in(email:, password:)
    return { success: false, error: 'Supabase not configured' } unless configured?

    response = post('/auth/v1/token?grant_type=password', {
      email: email,
      password: password
    })

    if response[:status] == 200
      data = response[:body]
      {
        success: true,
        user: {
          id: data.dig('user', 'id'),
          email: data.dig('user', 'email')
        },
        access_token: data['access_token'],
        refresh_token: data['refresh_token']
      }
    else
      error_message = extract_error(response[:body])
      Rails.logger.warn("[SupabaseAuthService] sign_in failed: #{error_message}")
      { success: false, error: map_supabase_error(error_message) }
    end
  rescue => e
    Rails.logger.error("[SupabaseAuthService] sign_in error: #{e.message}")
    { success: false, error: I18n.t('auth.errors.service_unavailable') }
  end

  # Sign up with email and password
  #
  # @param email [String] User's email address
  # @param password [String] User's password
  # @return [Hash] Result with :success, :user, :confirmation_required, or :error
  def self.sign_up(email:, password:)
    return { success: false, error: 'Supabase not configured' } unless configured?

    response = post('/auth/v1/signup', {
      email: email,
      password: password
    })

    if [200, 201].include?(response[:status])
      data = response[:body]
      user = data['user'] || data

      # Supabase returns identities as empty array when email confirmation is required
      confirmation_required = user['identities']&.empty? == true ||
        user['email_confirmed_at'].nil?

      {
        success: true,
        user: {
          id: user['id'],
          email: user['email']
        },
        access_token: data['access_token'],
        confirmation_required: confirmation_required
      }
    else
      error_message = extract_error(response[:body])
      Rails.logger.warn("[SupabaseAuthService] sign_up failed: #{error_message}")
      { success: false, error: map_supabase_error(error_message) }
    end
  rescue => e
    Rails.logger.error("[SupabaseAuthService] sign_up error: #{e.message}")
    { success: false, error: I18n.t('auth.errors.service_unavailable') }
  end

  # Sign out by invalidating the access token
  #
  # @param access_token [String] The user's access token
  # @return [Hash] Result with :success or :error
  def self.sign_out(access_token:)
    return { success: false, error: 'Supabase not configured' } unless configured?

    response = post('/auth/v1/logout', {}, access_token: access_token)

    if [200, 204].include?(response[:status])
      { success: true }
    else
      Rails.logger.warn("[SupabaseAuthService] sign_out failed with status #{response[:status]}")
      { success: false, error: 'Sign out failed' }
    end
  rescue => e
    Rails.logger.error("[SupabaseAuthService] sign_out error: #{e.message}")
    { success: false, error: I18n.t('auth.errors.service_unavailable') }
  end

  # Get current user info from access token
  #
  # @param access_token [String] The user's access token
  # @return [Hash] Result with :success, :user, or :error
  def self.get_user(access_token:)
    return { success: false, error: 'Supabase not configured' } unless configured?

    response = get('/auth/v1/user', access_token: access_token)

    if response[:status] == 200
      user = response[:body]
      {
        success: true,
        user: {
          id: user['id'],
          email: user['email']
        }
      }
    else
      { success: false, error: 'Invalid or expired token' }
    end
  rescue => e
    Rails.logger.error("[SupabaseAuthService] get_user error: #{e.message}")
    { success: false, error: I18n.t('auth.errors.service_unavailable') }
  end

  private

  def self.configured?
    SUPABASE_URL.present? && SUPABASE_KEY.present?
  end

  def self.base_headers(access_token: nil)
    headers = {
      'Content-Type' => 'application/json',
      'apikey' => SUPABASE_KEY
    }
    headers['Authorization'] = "Bearer #{access_token}" if access_token.present?
    headers
  end

  def self.post(path, body, access_token: nil)
    uri = URI.parse("#{SUPABASE_URL}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.read_timeout = 10
    http.open_timeout = 5

    request = Net::HTTP::Post.new(uri.request_uri, base_headers(access_token: access_token))
    request.body = body.to_json

    response = http.request(request)
    parse_response(response)
  end

  def self.get(path, access_token: nil)
    uri = URI.parse("#{SUPABASE_URL}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.read_timeout = 10
    http.open_timeout = 5

    request = Net::HTTP::Get.new(uri.request_uri, base_headers(access_token: access_token))

    response = http.request(request)
    parse_response(response)
  end

  def self.parse_response(response)
    status = response.code.to_i
    body_str = response.body.to_s
    body = begin
      body_str.empty? ? {} : JSON.parse(body_str)
    rescue JSON::ParserError
      { 'message' => body_str }
    end
    { status: status, body: body }
  end

  def self.extract_error(body)
    body.is_a?(Hash) ? (body['error_description'] || body['message'] || body['error'] || 'Unknown error') : 'Unknown error'
  end

  def self.map_supabase_error(message)
    case message.to_s.downcase
    when /invalid login credentials/, /invalid email or password/
      I18n.t('auth.errors.invalid_credentials')
    when /email not confirmed/
      I18n.t('auth.errors.email_not_confirmed')
    when /user already registered/, /already been registered/
      I18n.t('auth.errors.email_already_taken')
    when /password should be at least/
      I18n.t('auth.errors.password_too_short')
    when /unable to validate email address/
      I18n.t('auth.errors.invalid_email')
    else
      message
    end
  end
end
