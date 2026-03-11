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
        get :print_qr
        get :live_qrcode
      end
    end

    get "dashboard", to: "dashboard#index"
    get "dashboard/help", to: "dashboard#help"
    get "dashboard/count_users", to: "dashboard#count_users"
    get "dashboard/count_stamps", to: "dashboard#count_stamps"
    get "dashboard/count_coupons", to: "dashboard#count_coupons"
    get "dashboard/activity", to: "dashboard#activity"
    get "dashboard/coupons", to: "dashboard#coupons"

    get "scan/:token", to: "scans#show", as: :scan
    get "scan-success", to: "scans#success", as: :scan_success
    get "scan-reward",  to: "scans#reward",  as: :scan_reward
    get "scan-expired", to: "scans#expired",  as: :scan_expired

    get "lookup",          to: "lookup#index"
    get "lookup/search",   to: "lookup#search"
    get "lookup/user/:id", to: "lookup#show", as: :lookup_user
  end

  namespace :users do
    get "dashboard", to: "dashboard#index"
    get "dashboard/help", to: "dashboard#help"
    get "dashboard/your_card", to: "dashboard#your_card"
    get "dashboard/qr/:id", to: "dashboard#qr", as: :dashboard_qr

    get "scan/:token", to: "scans#show", as: :scan
    get "scan-success", to: "scans#success", as: :scan_success
    get "scan-reward",  to: "scans#reward",  as: :scan_reward
    get "scan-expired", to: "scans#expired",  as: :scan_expired
    get "scan/create_user_card/:token", to: "scans#create_user_card", as: :scan_create_user_card
  end

  resources :coupons do
    member do
      get :qr
    end
    collection do
      get :check
      post :redeem
    end
    get :activities, on: :collection
  end
end
