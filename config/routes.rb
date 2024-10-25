Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions'}

  authenticated :user do
    get 'home/index', to: 'home#index', as: :authenticated_root
    get 'client/dashboard', to: 'client#dashboard', as: :client_dashboard
  end

  root 'home#index'

  namespace :admin do
    resources :users
  end

end

