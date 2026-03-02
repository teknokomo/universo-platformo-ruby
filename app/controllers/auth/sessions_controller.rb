# Auth::SessionsController - HTML form-based Supabase authentication
#
# Routes:
#   GET    /auth/sign-in  -> new      (sign-in form)
#   POST   /auth/sign-in  -> create   (process sign-in)
#   GET    /auth/sign-up  -> sign_up  (sign-up form)
#   POST   /auth/sign-up  -> register (process sign-up)
#   DELETE /auth/sign-out -> destroy  (sign-out)
#
# Security note: HTML forms include CSRF tokens via Rails' form_with helper,
# so no skip_before_action is needed here.
class Auth::SessionsController < ApplicationController
  def new
    redirect_to root_path if user_signed_in?
  end

  def sign_up
    redirect_to root_path if user_signed_in?
  end

  # Process sign-in via Supabase
  def create
    email    = params[:email]&.strip
    password = params[:password]

    unless email.present? && password.present?
      flash.now[:alert] = t('auth.errors.email_password_required')
      render :new, status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_in(email: email, password: password)

    if result[:success]
      reset_session                                 # prevent session fixation
      session[:user_id]      = result[:user][:id]
      session[:user_email]   = result[:user][:email]
      session[:access_token] = result[:access_token]
      redirect_to root_path, notice: t('auth.messages.signed_in')
    else
      flash.now[:alert] = result[:error] || t('auth.errors.sign_in_failed')
      render :new, status: :unprocessable_entity
    end
  end

  # Process registration via Supabase
  def register
    email                 = params[:email]&.strip
    password              = params[:password]
    password_confirmation = params[:password_confirmation]

    unless email.present? && password.present?
      flash.now[:alert] = t('auth.errors.email_password_required')
      render :sign_up, status: :unprocessable_entity and return
    end

    if password != password_confirmation
      flash.now[:alert] = t('auth.errors.passwords_do_not_match')
      render :sign_up, status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_up(email: email, password: password)

    if result[:success]
      if result[:confirmation_required]
        redirect_to auth_sign_in_path, notice: t('auth.messages.check_email')
      else
        reset_session                                 # prevent session fixation
        session[:user_id]      = result[:user][:id]
        session[:user_email]   = result[:user][:email]
        session[:access_token] = result[:access_token]
        redirect_to root_path, notice: t('auth.messages.signed_up')
      end
    else
      flash.now[:alert] = result[:error] || t('auth.errors.sign_up_failed')
      render :sign_up, status: :unprocessable_entity
    end
  end

  # Sign out: invalidate Supabase token, then clear the local session
  def destroy
    SupabaseAuthService.sign_out(access_token: session[:access_token]) if session[:access_token].present?
    reset_session
    redirect_to root_path, notice: t('auth.messages.signed_out')
  end
end
