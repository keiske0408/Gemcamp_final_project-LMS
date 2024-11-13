Rails.application.routes.draw do
  get 'lottery/index'
  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'admin/sessions'
    }

    namespace :admin do
      # resources :home, only: [:index]
      resources :items do
        member do
          patch :start
          patch :pause
          patch :end
          patch :cancel
        end
      end
      resources :categories
    end


  root to: 'admin/home#index', as: :admin_root # Root for admin domain
end

constraints(ClientDomainConstraint.new) do
  devise_for :client, class_name: 'User', controllers: {
    sessions: 'client/sessions',
    registrations: 'client/registrations',
  }
  # Define the root within devise_scope to fix the mapping issue
  devise_scope :client do
    root to: 'client/home#new', as: :client_root
  end

  namespace :client do
    resources :home, only: [:index, :new]
    resource :me, controller: :me, only: [:show]
    resources :locations
    get 'invite-people', to: 'invitations#show', as: :invite_people
    get '/lottery', to: 'lottery#index', as: 'lottery'
  end
end

namespace :api do
  namespace :v1 do
    resources :regions, only: %i[index show], defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json }
    end

    resources :provinces, only: %i[index show], defaults: { format: :json } do
      resources :cities, only: :index, defaults: { format: :json }
    end

    resources :cities, only: %i[index show], defaults: { format: :json } do
      resources :barangays, only: :index, defaults: { format: :json }
    end

    resources :barangays, only: %i[index show], defaults: { format: :json }

  end
end
end




