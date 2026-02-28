# API::V1::AuthController - JSON API endpoints for authentication
#
# Routes:
# POST /api/v1/auth/sign-in  -> create  (login, returns tokens)
# POST /api/v1/auth/sign-up  -> register (registration)
# DELETE /api/v1/auth/sign-out -> destroy (logout)
# GET  /api/v1/auth/csrf     -> csrf    (CSRF token)
# GET  /api/v1/auth/me       -> me      (current user info)
class Api::V1::AuthController < ApplicationController
  # JSON requests are handled by ApplicationController's
  # protect_from_forgery with: :null_session, if: :json_request?
  # which resets the session instead of raising an exception.
  # Clients should obtain a CSRF token via GET /api/v1/auth/csrf and
  # include it as the X-CSRF-Token header in state-changing requests.

  # GET /api/v1/auth/csrf
  # Returns CSRF token for use in subsequent requests
  def csrf
    render json: { csrfToken: form_authenticity_token }
  end

  # GET /api/v1/auth/me
  # Returns current user information
  def me
    if user_signed_in?
      render json: {
        authenticated: true,
        user: {
          id: current_user[:id],
          email: current_user[:email]
        }
      }
    else
      render json: { authenticated: false, user: nil }
    end
  end

  # POST /api/v1/auth/sign-in
  def create
    email = params[:email]&.strip
    password = params[:password]

    unless email.present? && password.present?
      render json: { error: I18n.t('auth.errors.email_password_required') }, status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_in(email: email, password: password)

    if result[:success]
      session[:user_id] = result[:user][:id]
      session[:user_email] = result[:user][:email]
      session[:access_token] = result[:access_token]

      render json: {
        user: { id: result[:user][:id], email: result[:user][:email] },
        access_token: result[:access_token]
      }
    else
      render json: { error: result[:error] || I18n.t('auth.errors.sign_in_failed') },
        status: :unauthorized
    end
  end

  # POST /api/v1/auth/sign-up
  def register
    email = params[:email]&.strip
    password = params[:password]

    unless email.present? && password.present?
      render json: { error: I18n.t('auth.errors.email_password_required') }, status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_up(email: email, password: password)

    if result[:success]
      if result[:confirmation_required]
        render json: { message: I18n.t('auth.messages.check_email'), confirmation_required: true }
      else
        session[:user_id] = result[:user][:id]
        session[:user_email] = result[:user][:email]
        session[:access_token] = result[:access_token]

        render json: {
          user: { id: result[:user][:id], email: result[:user][:email] },
          access_token: result[:access_token]
        }, status: :created
      end
    else
      render json: { error: result[:error] || I18n.t('auth.errors.sign_up_failed') },
        status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/auth/sign-out
  def destroy
    if session[:access_token].present?
      SupabaseAuthService.sign_out(access_token: session[:access_token])
    end

    session.delete(:user_id)
    session.delete(:user_email)
    session.delete(:access_token)

    render json: { message: I18n.t('auth.messages.signed_out') }
  end
end
