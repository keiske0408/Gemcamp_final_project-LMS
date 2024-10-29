Rails.application.routes.draw do
<<<<<<< HEAD
  devise_for :users, controllers: { sessions: 'users/sessions' }, path: 'client'

  # Admin-specific routes
  constraints AdminDomainConstraint.new do
    namespace :admin do
      root 'home#index' # Admin dashboard
    end
=======

  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'admin/sessions'
    }

    namespace :admin do
      resources :home, only: [:index]
    end

    root to: 'admin/home#index', as: :admin_root # Root for admin domain
  end

  constraints(ClientDomainConstraint.new) do
    devise_for :client, class_name: 'User', controllers: {
      sessions: 'client/sessions',
      registrations: 'users/client/registrations'
    }
    root to: 'client/home#new', as: :client_root
    # Define the root within devise_scope to fix the mapping issue
    devise_scope :client do
      root to: 'client/home#new', as: :client_root
    end

    namespace :client do
      resources :home, only: [:index, :new]
    end
>>>>>>> Feature-2-and-3
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
<<<<<<< HEAD





=======
>>>>>>> Feature-2-and-3
