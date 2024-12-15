Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    devise_for :admin, class_name: 'User', only: [:sessions], controllers: {
      sessions: 'admin/sessions'
    }

    namespace :admin do
      resources :member_levels
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
      resources :tickets do
        member do
          patch :cancel
        end
      end

      resources :winners, only: [:index] do
        member do
          post :submit
          post :pay
          post :ship
          post :deliver
          post :publish
          post :remove_publish
          post :re_publish
        end
      end

      resources :offers

      resources :orders, only: [:index] do
        member do
          post :pay
          post :cancel
        end
      end

      resources :users, only: [] do
        collection do
          get :invite_list
        end
      end

      resources :news_tickers
      resources :banners

      resources :users, only: :index, path: 'users/clients' do
        member do
          resources :orders, only: [] do
            collection do
              get 'increase/new', to: 'balances#new_increase', as: :new_increase
              post 'increase', to: 'balances#create_increase', as: :create_increase

              get 'deduct/new', to: 'balances#new_deduct', as: :new_deduct
              post 'orders/deduct', to: 'balances#create_deduct_order', as: :create_deduct

              get 'bonus/new', to: 'balances#new_bonus', as: :new_bonus
              post 'bonus', to: 'balances#create_bonus', as: :create_bonus

              get 'member_level/new', to: 'balances#new_member_level', as: :new_member_level
              post 'member_level', to: 'balances#update_member_level', as: :update_member_level
            end
          end
        end
      end
    end
    root to: 'admin/users#index', as: :admin_root # Root for admin domain
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

      resources :shares, only: [:edit, :update, :index, :show]
      resources :home, only: [:index, :new]
      resource :me, controller: :me, only: [:show] do
        get 'order_history', to: 'me#order_history'
        get 'lottery_history', to: 'me#lottery_history'
        get 'invitation_history', to: 'me#invitation_history'
        get 'winning_history', to: 'me#winning_history'
        get 'share_feedback', to: 'me#share_feedback'
        member do
          patch :claim_prize
          post :publish
          post :cancel_order
        end
      end

      resources :locations do
        get :details
      end

      resources :lottery, only: [:index, :show] do
        member do
          post :buy_tickets
        end
      end

      resources :categories, only: [:index]

      resources :shop, only: [:index, :show] do
        member do
          post :purchase
        end
      end
      get 'invite-people', to: 'invitations#show'
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




