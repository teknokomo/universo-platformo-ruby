# SupabaseAuthService - Handles authentication via Supabase REST API
#
# All communication with Supabase happens here, on the backend.
# Credentials are never exposed to the browser.
#
# Configuration (environment variables):
#   SUPABASE_URL  - Supabase project URL  (e.g. https://abc.supabase.co)
#   SUPABASE_KEY  - Supabase anon key     (used for Auth operations)
require 'net/http'
require 'json'
require 'uri'
require 'openssl'

class SupabaseAuthService
  # Read Supabase connection details from environment at class load time.
  # Tests can override with stub_const.
  SUPABASE_URL = ENV.fetch('SUPABASE_URL', nil)
  SUPABASE_KEY = ENV.fetch('SUPABASE_KEY', nil)

  class << self
    # Sign in with email and password
    #
    # @param email    [String] User email address
    # @param password [String] User password
    # @return [Hash]  :success, :user, :access_token / :error
    def sign_in(email:, password:)
      return unconfigured_error unless configured?

      response = post('/auth/v1/token?grant_type=password',
                      { email: email, password: password })

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

    # Register a new user with email and password
    #
    # @param email    [String] User email address
    # @param password [String] User password
    # @return [Hash]  :success, :user, :confirmation_required / :error
    def sign_up(email:, password:)
      return unconfigured_error unless configured?

      response = post('/auth/v1/signup', { email: email, password: password })

      if [200, 201].include?(response[:status])
        data = response[:body]
        user = data['user'] || data

        # Supabase returns an empty identities array when email confirmation is required
        confirmation_required = user['identities']&.empty? == true ||
                                user['email_confirmed_at'].nil?

        {
          success: true,
          user: { id: user['id'], email: user['email'] },
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

    # Invalidate a user's access token (sign out on Supabase side)
    #
    # @param access_token [String] The user's current access token
    # @return [Hash] :success / :error
    def sign_out(access_token:)
      return unconfigured_error unless configured?

      response = post('/auth/v1/logout', {}, access_token: access_token)

      if [200, 204].include?(response[:status])
        { success: true }
      else
        Rails.logger.warn("[SupabaseAuthService] sign_out failed (status #{response[:status]})")
        { success: false, error: 'Sign out failed' }
      end
    rescue => e
      Rails.logger.error("[SupabaseAuthService] sign_out error: #{e.message}")
      { success: false, error: I18n.t('auth.errors.service_unavailable') }
    end

    # Fetch user information for a given access token
    #
    # @param access_token [String] The user's access token
    # @return [Hash] :success, :user / :error
    def get_user(access_token:)
      return unconfigured_error unless configured?

      response = get('/auth/v1/user', access_token: access_token)

      if response[:status] == 200
        user = response[:body]
        { success: true, user: { id: user['id'], email: user['email'] } }
      else
        { success: false, error: 'Invalid or expired token' }
      end
    rescue => e
      Rails.logger.error("[SupabaseAuthService] get_user error: #{e.message}")
      { success: false, error: I18n.t('auth.errors.service_unavailable') }
    end

    private

    def configured?
      SUPABASE_URL.present? && SUPABASE_KEY.present?
    end

    def unconfigured_error
      { success: false, error: 'Supabase not configured' }
    end

    def base_headers(access_token: nil)
      headers = {
        'Content-Type' => 'application/json',
        'apikey' => SUPABASE_KEY
      }
      headers['Authorization'] = "Bearer #{access_token}" if access_token.present?
      headers
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.read_timeout = 10
      http.open_timeout = 5
      http
    end

    def post(path, body, access_token: nil)
      uri = URI.parse("#{SUPABASE_URL}#{path}")
      request = Net::HTTP::Post.new(uri.request_uri, base_headers(access_token: access_token))
      request.body = body.to_json
      parse_response(build_http(uri).request(request))
    end

    def get(path, access_token: nil)
      uri = URI.parse("#{SUPABASE_URL}#{path}")
      request = Net::HTTP::Get.new(uri.request_uri, base_headers(access_token: access_token))
      parse_response(build_http(uri).request(request))
    end

    def parse_response(response)
      status = response.code.to_i
      body_str = response.body.to_s
      body = begin
        body_str.empty? ? {} : JSON.parse(body_str)
      rescue JSON::ParserError
        { 'message' => body_str }
      end
      { status: status, body: body }
    end

    def extract_error(body)
      return 'Unknown error' unless body.is_a?(Hash)

      body['error_description'] || body['message'] || body['error'] || 'Unknown error'
    end

    def map_supabase_error(message)
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
end
