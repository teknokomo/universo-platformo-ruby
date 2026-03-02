require 'rails_helper'

RSpec.describe 'Auth::Sessions', type: :request do
  describe 'GET /auth/sign-in' do
    it 'returns HTTP success' do
      get auth_sign_in_path
      expect(response).to have_http_status(:success)
    end

    it 'displays the sign-in form' do
      get auth_sign_in_path
      expect(response.body).to include(I18n.t('auth.sign_in'))
      expect(response.body).to include(I18n.t('auth.email'))
      expect(response.body).to include(I18n.t('auth.password'))
    end

    it 'displays a link to the sign-up page' do
      get auth_sign_in_path
      expect(response.body).to include(auth_sign_up_path)
    end

    context 'when user is already authenticated' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:user_signed_in?).and_return(true)
      end

      it 'redirects to root' do
        get auth_sign_in_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /auth/sign-up' do
    it 'returns HTTP success' do
      get auth_sign_up_path
      expect(response).to have_http_status(:success)
    end

    it 'displays the sign-up form' do
      get auth_sign_up_path
      expect(response.body).to include(I18n.t('auth.create_account'))
      expect(response.body).to include(I18n.t('auth.email'))
      expect(response.body).to include(I18n.t('auth.password_confirmation'))
    end

    it 'displays a link to the sign-in page' do
      get auth_sign_up_path
      expect(response.body).to include(auth_sign_in_path)
    end
  end

  describe 'POST /auth/sign-in' do
    context 'with valid credentials' do
      before do
        allow(SupabaseAuthService).to receive(:sign_in).with(
          email: 'test@example.com',
          password: 'password123'
        ).and_return({
          success: true,
          user: { id: 'user-123', email: 'test@example.com' },
          access_token: 'access-token-abc'
        })
      end

      it 'redirects to root path' do
        post auth_sign_in_path, params: { email: 'test@example.com', password: 'password123' }
        expect(response).to redirect_to(root_path)
      end

      it 'sets session variables' do
        post auth_sign_in_path, params: { email: 'test@example.com', password: 'password123' }
        expect(session[:user_id]).to eq('user-123')
        expect(session[:user_email]).to eq('test@example.com')
        expect(session[:access_token]).to eq('access-token-abc')
      end
    end

    context 'with invalid credentials' do
      before do
        allow(SupabaseAuthService).to receive(:sign_in).and_return({
          success: false,
          error: I18n.t('auth.errors.invalid_credentials')
        })
      end

      it 'returns unprocessable entity' do
        post auth_sign_in_path, params: { email: 'bad@example.com', password: 'wrongpass' }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'displays error message' do
        post auth_sign_in_path, params: { email: 'bad@example.com', password: 'wrongpass' }
        expect(response.body).to include(I18n.t('auth.errors.invalid_credentials'))
      end
    end

    context 'with missing params' do
      it 'returns unprocessable entity when email is blank' do
        post auth_sign_in_path, params: { email: '', password: 'password' }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns unprocessable entity when password is blank' do
        post auth_sign_in_path, params: { email: 'test@example.com', password: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /auth/sign-up' do
    context 'with valid data and confirmation required' do
      before do
        allow(SupabaseAuthService).to receive(:sign_up).with(
          email: 'new@example.com',
          password: 'password123'
        ).and_return({
          success: true,
          user: { id: 'user-456', email: 'new@example.com' },
          confirmation_required: true
        })
      end

      it 'redirects to sign-in with notice' do
        post auth_sign_up_path, params: {
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
        expect(response).to redirect_to(auth_sign_in_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('auth.messages.check_email'))
      end
    end

    context 'when passwords do not match' do
      it 'returns unprocessable entity' do
        post auth_sign_up_path, params: {
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'different'
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'displays password mismatch error' do
        post auth_sign_up_path, params: {
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'different'
        }
        expect(response.body).to include(I18n.t('auth.errors.passwords_do_not_match'))
      end
    end
  end

  describe 'DELETE /auth/sign-out' do
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:user_signed_in?).and_return(true)
      allow(SupabaseAuthService).to receive(:sign_out).and_return({ success: true })
    end

    it 'redirects to root path' do
      delete auth_sign_out_path
      expect(response).to redirect_to(root_path)
    end

    it 'clears session data' do
      delete auth_sign_out_path
      expect(session[:user_id]).to be_nil
      expect(session[:user_email]).to be_nil
      expect(session[:access_token]).to be_nil
    end
  end

  describe 'GET /api/v1/auth/csrf' do
    it 'returns a CSRF token' do
      get api_v1_auth_csrf_path, headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('csrfToken')
    end
  end

  describe 'GET /api/v1/auth/me' do
    context 'when not authenticated' do
      it 'returns authenticated: false' do
        get api_v1_auth_me_path, headers: { 'Accept' => 'application/json' }
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['authenticated']).to eq(false)
      end
    end

    context 'when authenticated' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:user_signed_in?).and_return(true)
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user).and_return({ id: 'user-123', email: 'test@example.com' })
      end

      it 'returns authenticated: true with user info' do
        get api_v1_auth_me_path, headers: { 'Accept' => 'application/json' }
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['authenticated']).to eq(true)
        expect(json['user']['email']).to eq('test@example.com')
      end
    end
  end

  describe 'POST /api/v1/auth/sign-in' do
    let(:json_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

    context 'with valid credentials' do
      before do
        allow(SupabaseAuthService).to receive(:sign_in).with(
          email: 'test@example.com',
          password: 'password123'
        ).and_return({
          success: true,
          user: { id: 'user-123', email: 'test@example.com' },
          access_token: 'access-token-abc'
        })
      end

      it 'returns user info without access_token' do
        post api_v1_sign_in_path,
             params: { email: 'test@example.com', password: 'password123' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['user']['email']).to eq('test@example.com')
        expect(json).not_to have_key('access_token')
      end

      it 'sets session variables' do
        post api_v1_sign_in_path,
             params: { email: 'test@example.com', password: 'password123' }.to_json,
             headers: json_headers
        expect(session[:user_id]).to eq('user-123')
        expect(session[:access_token]).to eq('access-token-abc')
      end
    end

    context 'with invalid credentials' do
      before do
        allow(SupabaseAuthService).to receive(:sign_in).and_return({
          success: false,
          error: I18n.t('auth.errors.invalid_credentials'),
          status: :invalid_credentials
        })
      end

      it 'returns 401 unauthorized' do
        post api_v1_sign_in_path,
             params: { email: 'bad@example.com', password: 'wrong' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when service is unavailable' do
      before do
        allow(SupabaseAuthService).to receive(:sign_in).and_return({
          success: false,
          error: I18n.t('auth.errors.service_unavailable'),
          status: :service_unavailable
        })
      end

      it 'returns 503 service unavailable' do
        post api_v1_sign_in_path,
             params: { email: 'test@example.com', password: 'password123' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:service_unavailable)
      end
    end

    context 'with missing params' do
      it 'returns 422 unprocessable entity' do
        post api_v1_sign_in_path,
             params: { email: '', password: '' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/auth/sign-up' do
    let(:json_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

    context 'with valid data and immediate confirmation' do
      before do
        allow(SupabaseAuthService).to receive(:sign_up).with(
          email: 'new@example.com',
          password: 'password123'
        ).and_return({
          success: true,
          user: { id: 'user-456', email: 'new@example.com' },
          access_token: 'new-token',
          confirmation_required: false
        })
      end

      it 'returns 201 created with user info' do
        post api_v1_sign_up_path,
             params: { email: 'new@example.com', password: 'password123' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['user']['email']).to eq('new@example.com')
        expect(json).not_to have_key('access_token')
      end
    end

    context 'with valid data and confirmation required' do
      before do
        allow(SupabaseAuthService).to receive(:sign_up).with(
          email: 'new@example.com',
          password: 'password123'
        ).and_return({
          success: true,
          user: { id: 'user-456', email: 'new@example.com' },
          confirmation_required: true
        })
      end

      it 'returns confirmation_required message' do
        post api_v1_sign_up_path,
             params: { email: 'new@example.com', password: 'password123' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['confirmation_required']).to eq(true)
      end
    end

    context 'when service is unavailable' do
      before do
        allow(SupabaseAuthService).to receive(:sign_up).and_return({
          success: false,
          error: I18n.t('auth.errors.service_unavailable'),
          status: :service_unavailable
        })
      end

      it 'returns 503 service unavailable' do
        post api_v1_sign_up_path,
             params: { email: 'new@example.com', password: 'password123' }.to_json,
             headers: json_headers
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end

  describe 'DELETE /api/v1/auth/sign-out' do
    let(:json_headers) { { 'Accept' => 'application/json' } }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:user_signed_in?).and_return(true)
      allow(SupabaseAuthService).to receive(:sign_out).and_return({ success: true })
    end

    it 'returns success message' do
      delete api_v1_sign_out_path, headers: json_headers
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['message']).to eq(I18n.t('auth.messages.signed_out'))
    end

    it 'clears session data' do
      delete api_v1_sign_out_path, headers: json_headers
      expect(session[:user_id]).to be_nil
      expect(session[:access_token]).to be_nil
    end
  end
end
