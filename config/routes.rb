Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route - routes to guest or authenticated start page based on auth status
  root "start#index"

  # Start pages
  scope :start do
    get :guest, controller: :start, as: :start_guest
    get :authenticated, controller: :start, as: :start_authenticated
  end

  # Authentication routes (HTML)
  scope :auth, module: :auth do
    get  "sign-in",  to: "sessions#new",      as: :auth_sign_in
    post "sign-in",  to: "sessions#create"
    get  "sign-up",  to: "sessions#sign_up",  as: :auth_sign_up
    post "sign-up",  to: "sessions#register"
    delete "sign-out", to: "sessions#destroy", as: :auth_sign_out
  end

  # JSON API routes for authentication (used by frontend JS)
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      scope :auth do
        get    "csrf",     to: "auth#csrf",    as: :auth_csrf
        get    "me",       to: "auth#me",      as: :auth_me
        post   "sign-in",  to: "auth#create",  as: :sign_in
        post   "sign-up",  to: "auth#register", as: :sign_up
        delete "sign-out", to: "auth#destroy", as: :sign_out
      end
    end
  end

  # Clusters functionality routes (to be implemented)
  # resources :clusters do
  #   resources :domains do
  #     resources :resources
  #   end
  # end
end
