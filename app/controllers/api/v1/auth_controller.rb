# Api::V1::AuthController - JSON API endpoints for Supabase authentication
#
# Routes:
#   GET    /api/v1/auth/csrf     -> csrf     (obtain CSRF token)
#   GET    /api/v1/auth/me       -> me       (current user info)
#   POST   /api/v1/auth/sign-in  -> create   (sign in, sets session)
#   POST   /api/v1/auth/sign-up  -> register (sign up, sets session)
#   DELETE /api/v1/auth/sign-out -> destroy  (sign out, clears session)
#
# Security: ApplicationController applies protect_from_forgery with :exception
# for all requests. JSON clients must obtain a CSRF token via GET /api/v1/auth/csrf
# and include it as the X-CSRF-Token header in state-changing requests (POST/DELETE).
# Supabase credentials and tokens are never exposed to the browser.
class Api::V1::AuthController < ApplicationController
  # GET /api/v1/auth/csrf
  def csrf
    render json: { csrfToken: form_authenticity_token }
  end

  # GET /api/v1/auth/me
  def me
    if user_signed_in?
      render json: {
        authenticated: true,
        user: { id: current_user[:id], email: current_user[:email] }
      }
    else
      render json: { authenticated: false, user: nil }
    end
  end

  # POST /api/v1/auth/sign-in
  def create
    email    = params[:email]&.strip
    password = params[:password]

    unless email.present? && password.present?
      render json: { error: I18n.t('auth.errors.email_password_required') },
             status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_in(email: email, password: password)

    if result[:success]
      reset_session                                   # prevent session fixation
      session[:user_id]      = result[:user][:id]
      session[:user_email]   = result[:user][:email]
      session[:access_token] = result[:access_token]
      render json: {
        user: { id: result[:user][:id], email: result[:user][:email] }
      }
    else
      http_status = case result[:status]
                    when :service_unavailable then :service_unavailable
                    when :not_configured then :internal_server_error
                    else :unauthorized
                    end
      render json: { error: result[:error] || I18n.t('auth.errors.sign_in_failed') },
             status: http_status
    end
  end

  # POST /api/v1/auth/sign-up
  def register
    email    = params[:email]&.strip
    password = params[:password]

    unless email.present? && password.present?
      render json: { error: I18n.t('auth.errors.email_password_required') },
             status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_up(email: email, password: password)

    if result[:success]
      if result[:confirmation_required]
        render json: { message: I18n.t('auth.messages.check_email'), confirmation_required: true }
      else
        reset_session                                 # prevent session fixation
        session[:user_id]      = result[:user][:id]
        session[:user_email]   = result[:user][:email]
        session[:access_token] = result[:access_token]
        render json: {
          user: { id: result[:user][:id], email: result[:user][:email] }
        }, status: :created
      end
    else
      http_status = case result[:status]
                    when :service_unavailable then :service_unavailable
                    when :not_configured then :internal_server_error
                    else :unprocessable_entity
                    end
      render json: { error: result[:error] || I18n.t('auth.errors.sign_up_failed') },
             status: http_status
    end
  end

  # DELETE /api/v1/auth/sign-out
  def destroy
    SupabaseAuthService.sign_out(access_token: session[:access_token]) if session[:access_token].present?
    reset_session
    render json: { message: I18n.t('auth.messages.signed_out') }
  end
end
