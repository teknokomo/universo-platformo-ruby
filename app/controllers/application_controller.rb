class ApplicationController < ActionController::Base
  # Security: verify authenticity token for all requests (HTML and JSON).
  # JSON clients must obtain a CSRF token via GET /api/v1/auth/csrf
  # and include it as the X-CSRF-Token header in state-changing requests.
  protect_from_forgery with: :exception

  before_action :set_locale

  helper_method :current_user, :user_signed_in?

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
  end

  # Returns the current authenticated user (from session)
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = if session[:user_id].present?
      { id: session[:user_id], email: session[:user_email] }
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to auth_sign_in_path, alert: t('messages.error.unauthorized') }
        format.json { render json: { error: t('messages.error.unauthorized') }, status: :unauthorized }
      end
    end
  end
end
