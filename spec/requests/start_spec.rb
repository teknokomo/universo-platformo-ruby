require 'rails_helper'

RSpec.describe 'Start pages', type: :request do
  describe 'GET /' do
    context 'when user is not authenticated' do
      it 'redirects to the guest start page' do
        get root_path
        expect(response).to redirect_to(start_guest_path)
      end
    end

    context 'when user is authenticated' do
      before do
        # Simulate authenticated session
        allow_any_instance_of(ApplicationController)
          .to receive(:user_signed_in?).and_return(true)
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user).and_return({ id: 'user-123', email: 'test@example.com' })
      end

      it 'redirects to the authenticated start page' do
        get root_path
        expect(response).to redirect_to(start_authenticated_path)
      end
    end
  end

  describe 'GET /start/guest' do
    it 'returns HTTP success' do
      get start_guest_path
      expect(response).to have_http_status(:success)
    end

    it 'displays the hero section title' do
      get start_guest_path
      expect(response.body).to include(I18n.t('landing.hero.title_highlight'))
    end

    it 'displays the call-to-action button' do
      get start_guest_path
      expect(response.body).to include(I18n.t('landing.hero.button'))
    end

    it 'displays sign in and sign up navigation links' do
      get start_guest_path
      expect(response.body).to include(I18n.t('auth.sign_in'))
      expect(response.body).to include(I18n.t('auth.sign_up'))
    end

    it 'displays 4 product cards' do
      get start_guest_path
      expect(response.body).to include(I18n.t('landing.testimonials.kompendio.title'))
      expect(response.body).to include(I18n.t('landing.testimonials.platformo.title'))
      expect(response.body).to include(I18n.t('landing.testimonials.kiberplano.title'))
      expect(response.body).to include(I18n.t('landing.testimonials.grandaringo.title'))
    end
  end

  describe 'GET /start/authenticated' do
    context 'when user is not authenticated' do
      it 'redirects to the sign-in page' do
        get start_authenticated_path
        expect(response).to redirect_to(auth_sign_in_path)
      end
    end

    context 'when user is authenticated' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:user_signed_in?).and_return(true)
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user).and_return({ id: 'user-123', email: 'test@example.com' })
      end

      it 'returns HTTP success' do
        get start_authenticated_path
        expect(response).to have_http_status(:success)
      end

      it 'displays the onboarding wizard' do
        get start_authenticated_path
        expect(response.body).to include(I18n.t('landing.onboarding.welcome.title'))
      end

      it 'displays the sign-out button' do
        get start_authenticated_path
        expect(response.body).to include(I18n.t('auth.sign_out'))
      end
    end
  end
end
