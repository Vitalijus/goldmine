Rails.application.routes.draw do
  get "pages/home"
  get "search", to: "pages#search"
  get "checkout", to: "pages#checkout"
  get "pages/download", to: "pages#download", defaults: { format: :csv }
  get "pages/export", to: "pages#export", defaults: { format: :csv }

  resources :companies
  resources :careers do
    resources :applicants, only: [:new, :create]
  end

  # Stripe webhooks endpoint
  post "/stripe_webhook", to: "webhooks#stripe_webhook"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
