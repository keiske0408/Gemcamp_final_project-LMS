Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }, path: 'client'

  # Admin-specific routes
  constraints AdminDomainConstraint.new do
    namespace :admin do
      root 'home#index' # Admin dashboard
    end
  end

  # Client routes with custom login path
  constraints ClientDomainConstraint.new do
    devise_scope :user do
      get 'client/login', to: 'client/sessions#new', as: :new_client_session
      post 'client/login', to: 'client/sessions#create', as: :client_session
      delete 'client/logout', to: 'client/sessions#destroy', as: :destroy_client_session
    end

    namespace :client do
      get 'dashboard', to: 'dashboard#index', as: :dashboard
      root 'dashboard#index' # Client dashboard
    end
  end

  # Default root path fallback
  root 'home#index'
end





