Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'admin/sessions'
    }

    # namespace :admin do
    #   resources :home, only: [:index]
    # end

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
      resources :menu, only: [:index]
    end
  end
end


