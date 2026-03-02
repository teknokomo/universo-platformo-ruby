require 'rails_helper'

RSpec.describe SupabaseAuthService do
  let(:supabase_url) { 'https://test.supabase.co' }
  let(:supabase_key) { 'test-anon-key' }

  before do
    stub_const('SupabaseAuthService::SUPABASE_URL', supabase_url)
    stub_const('SupabaseAuthService::SUPABASE_KEY', supabase_key)
  end

  describe '.sign_in' do
    context 'when Supabase is not configured' do
      before do
        stub_const('SupabaseAuthService::SUPABASE_URL', nil)
      end

      it 'returns an error result' do
        result = described_class.sign_in(email: 'test@example.com', password: 'password')
        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq(I18n.t('auth.errors.not_configured'))
      end
    end

    context 'when Supabase returns success' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/token?grant_type=password")
          .to_return(
            status: 200,
            body: {
              access_token: 'access-token-abc',
              refresh_token: 'refresh-token-xyz',
              user: { id: 'user-123', email: 'test@example.com' }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns success with user data' do
        result = described_class.sign_in(email: 'test@example.com', password: 'password123')
        expect(result[:success]).to eq(true)
        expect(result[:user][:id]).to eq('user-123')
        expect(result[:user][:email]).to eq('test@example.com')
        expect(result[:access_token]).to eq('access-token-abc')
      end
    end

    context 'when Supabase returns invalid credentials error' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/token?grant_type=password")
          .to_return(
            status: 400,
            body: {
              error: 'invalid_grant',
              error_description: 'Invalid login credentials'
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns failure with translated error message' do
        result = described_class.sign_in(email: 'bad@example.com', password: 'wrongpass')
        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq(I18n.t('auth.errors.invalid_credentials'))
      end
    end

    context 'when network error occurs' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/token?grant_type=password")
          .to_raise(StandardError.new('Connection refused'))
      end

      it 'returns service unavailable error' do
        result = described_class.sign_in(email: 'test@example.com', password: 'password')
        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq(I18n.t('auth.errors.service_unavailable'))
      end
    end
  end

  describe '.sign_up' do
    context 'when registration requires email confirmation' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/signup")
          .to_return(
            status: 200,
            body: {
              id: 'user-456',
              email: 'new@example.com',
              identities: [],
              email_confirmed_at: nil
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns success with confirmation_required: true' do
        result = described_class.sign_up(email: 'new@example.com', password: 'password123')
        expect(result[:success]).to eq(true)
        expect(result[:confirmation_required]).to eq(true)
      end
    end

    context 'when registration is immediately confirmed' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/signup")
          .to_return(
            status: 200,
            body: {
              access_token: 'new-access-token',
              user: {
                id: 'user-789',
                email: 'confirmed@example.com',
                email_confirmed_at: '2024-01-01T00:00:00Z',
                identities: [{ id: 'identity-1' }]
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns success with access token' do
        result = described_class.sign_up(email: 'confirmed@example.com', password: 'password123')
        expect(result[:success]).to eq(true)
        expect(result[:confirmation_required]).to eq(false)
        expect(result[:access_token]).to eq('new-access-token')
      end
    end

    context 'when email is already registered' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/signup")
          .to_return(
            status: 422,
            body: { message: 'User already registered' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns failure with email taken error' do
        result = described_class.sign_up(email: 'existing@example.com', password: 'password123')
        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq(I18n.t('auth.errors.email_already_taken'))
      end
    end
  end

  describe '.sign_out' do
    context 'when sign out succeeds' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/logout")
          .to_return(status: 204, body: '')
      end

      it 'returns success' do
        result = described_class.sign_out(access_token: 'valid-token')
        expect(result[:success]).to eq(true)
      end
    end

    context 'when sign out fails' do
      before do
        stub_request(:post, "#{supabase_url}/auth/v1/logout")
          .to_return(status: 401, body: '{"error":"invalid_token"}')
      end

      it 'returns failure' do
        result = described_class.sign_out(access_token: 'invalid-token')
        expect(result[:success]).to eq(false)
      end
    end
  end

  describe '.get_user' do
    context 'when token is valid' do
      before do
        stub_request(:get, "#{supabase_url}/auth/v1/user")
          .to_return(
            status: 200,
            body: { id: 'user-123', email: 'test@example.com' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns user information' do
        result = described_class.get_user(access_token: 'valid-token')
        expect(result[:success]).to eq(true)
        expect(result[:user][:id]).to eq('user-123')
        expect(result[:user][:email]).to eq('test@example.com')
      end
    end

    context 'when token is invalid' do
      before do
        stub_request(:get, "#{supabase_url}/auth/v1/user")
          .to_return(status: 401, body: '{"error":"invalid_token"}')
      end

      it 'returns failure' do
        result = described_class.get_user(access_token: 'invalid-token')
        expect(result[:success]).to eq(false)
      end
    end
  end
end
