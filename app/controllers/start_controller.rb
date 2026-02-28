# StartController - Handles start page routing based on authentication status
#
# Routes:
# GET /  -> index (redirects to guest or authenticated page)
# GET /start/guest -> guest (landing page for non-authenticated users)
# GET /start/authenticated -> authenticated (onboarding for authenticated users)
class StartController < ApplicationController
  def index
    if user_signed_in?
      redirect_to start_authenticated_path
    else
      redirect_to start_guest_path
    end
  end

  # Landing page for non-authenticated users
  # Displays hero section, product testimonials, and footer
  def guest
    render :guest
  end

  # Onboarding page for authenticated users
  # Displays onboarding wizard or completion screen
  def authenticated
    authenticate_user!
  end
end
