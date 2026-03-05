Rails.application.routes.draw do
  
  devise_for :customers, path: 'customers', controllers: {
    registrations: 'customers/registrations',
    sessions: 'customers/sessions'
  }
  devise_for :users, path: 'users', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :customer do  
    get '/customers/sign_out' => 'devise/sessions#destroy'     
  end

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "manifest" => "pwa#manifest", as: :pwa_manifest
  get "service-worker.js" => "pwa#service_worker"

  # Defines the root path route ("/")
  root "home#index"

  namespace :customers do
    resources :cards do
      member do
        get :qr
        get :live_qrcode
      end
    end
    get "dashboard", to: "dashboard#index"
  end

  namespace :users do
    get "dashboard", to: "dashboard#index"
    get "scan/:token", to: "scans#show", as: :scan
  end
end
