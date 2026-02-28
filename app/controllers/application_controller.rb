class ApplicationController < ActionController::Base
  # Security: verify authenticity token for non-JSON requests
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?

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
        format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end

  def json_request?
    request.format.json?
  end
end
