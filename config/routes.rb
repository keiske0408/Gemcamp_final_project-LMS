Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  constraints(AdminDomainConstraint.new) do
    namespace :client do
      resources :home, only: [:index]
    end

    get 'client/dashboard', to: 'client#dashboard', as: :client_dashboard
    root 'home#index'

    constraints(ClientDomainConstraint.new) do
      namespace :admin do
        resources :home, only: [:index]
      end
    end

  end
end



