# Auth::SessionsController - Handles Supabase authentication (login/register/logout)
#
# Routes:
# GET  /auth/sign-in  -> new     (shows login/register form)
# POST /auth/sign-in  -> create  (processes login)
# GET  /auth/sign-up  -> sign_up (shows registration form)
# POST /auth/sign-up  -> register (processes registration)
# DELETE /auth/sign-out -> destroy (processes logout)
class Auth::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :register, :destroy]

  def new
    # Redirect authenticated users away from the auth page
    redirect_to root_path if user_signed_in?
  end

  # Process login via Supabase
  def create
    email = params[:email]&.strip
    password = params[:password]

    unless email.present? && password.present?
      flash.now[:alert] = t('auth.errors.email_password_required')
      render :new, status: :unprocessable_entity and return
    end

    result = SupabaseAuthService.sign_in(email: email, password: password)

    if result[:success]
      session[:user_id] = result[:user][:id]
      session[:user_email] = result[:user][:email]
      session[:access_token] = result[:access_token]

      redirect_to root_path, notice: t('auth.messages.signed_in')
    else
      flash.now[:alert] = result[:error] || t('auth.errors.sign_in_failed')
      render :new, status: :unprocessable_entity
    end
  end

  # Show registration form (renders new template with sign_up mode)
  def sign_up
    redirect_to root_path if user_signed_in?
    render :sign_up
  end

  # Process registration via Supabase
  def register
    email = params[:email]&.strip
    password = params[:password]
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
        redirect_to auth_sign_in_path,
          notice: t('auth.messages.check_email')
      else
        session[:user_id] = result[:user][:id]
        session[:user_email] = result[:user][:email]
        session[:access_token] = result[:access_token]
        redirect_to root_path, notice: t('auth.messages.signed_up')
      end
    else
      flash.now[:alert] = result[:error] || t('auth.errors.sign_up_failed')
      render :sign_up, status: :unprocessable_entity
    end
  end

  # Process logout
  def destroy
    if session[:access_token].present?
      SupabaseAuthService.sign_out(access_token: session[:access_token])
    end

    session.delete(:user_id)
    session.delete(:user_email)
    session.delete(:access_token)

    redirect_to root_path, notice: t('auth.messages.signed_out')
  end
end
