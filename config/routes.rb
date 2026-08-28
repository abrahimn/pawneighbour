Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root to: "listings#index", as: :authenticated_root
  end
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :listings, only: [:index, :new, :create, :show], shallow: true do
    collection do
      get :mine
    end
    resources :offers, only: [:index, :show, :create] do
      patch :accept, on: :member
    end
  end
  resources :connections, only: [:index, :show, :create]

  resources :amber_alerts, only: [:index, :new, :create, :show] do
    patch :resolve, on: :member
    resources :alert_responses, only: [:create]
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
