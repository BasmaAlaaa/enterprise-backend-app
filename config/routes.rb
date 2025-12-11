Rails.application.routes.draw do
  devise_for :users ,defaults: { format: :json }, controllers: { omniauth_callbacks: 'authentication' }
  mount ActionCable.server => '/cable'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'alt_text', :to => 'home#index'
  get 'alt_text/products/:id', :to => 'home#index'
  get 'alt_text/product/:id', :to => 'home#index'
  get 'alt_text/collections/:id', :to => 'home#index'
  get 'alt_text/collection/:id', :to => 'home#index'
  get 'alt_text/blog_posts/:id', :to => 'home#index'
  get 'alt_text/blog_post/:blogId/:articleId', :to => 'home#index'
  get 'alt_text/medias/:id', :to => 'home#index'
  get 'alt_text/media/:id', :to => 'home#index'
  get 'alt_text/history', :to => 'home#index'

  namespace :webhooks do
    resources :shopify do 
      collection do
        get :shop_redact
        get :data_request
        get :customer_redact
      end
    end

    resources :callbacks do 
      collection do
        get :salla
        post :salla_easy_mode
        get :shopify
        get :shopify_direct_install
        post :wordpress
        get :refresh_salla_token
      end
    end
  end

  resources :search_console, only: [:index] do
    collection do
      get :google_oauth2
      post :performance
      post :performance_graph
      post :keyword_performance
      get :signout
    end
  end

  resources :google_auth, only: [] do
    collection do
      get :callback
    end
  end

  resources :keywords, only: [:index, :destroy] do
    collection do
      post :upsert
    end
  end

  namespace :integrations do
    resources :shopify , only: [] do
      resources :collections, module: 'shopify' , only: [:index, :show, :update] 
      resources :blogs, module: 'shopify', only: [:index]
      resources :articles, module: 'shopify', only: [:index, :show, :create, :update]
      resources :products, module: 'shopify'
      resources :media, module: 'shopify', only: [:index, :show,] 
      collection do
        get :install
      end
    end
    resources :salla , only: [] do
      resources :products, module: 'salla'
      collection do
        get :install
      end
      resources :collections, module: 'salla' , only: [:index, :show, :create, :update]
    end
    resources :wordpress, only: [] do
      resources :articles, module: 'wordpress'
      resources :products, module: 'wordpress'
      resources :collections, module: 'wordpress'
      resources :media, module: 'wordpress'
      collection do
        post :install
      end
    end
  end

  resources :auth do
    collection do
     post :social_login
    end
  end

  namespace :webhooks do
    resources :app_subscriptions_update, only: [:create] 
  end
  

  namespace :api do
    resources :keywords, only: [:create]
    resources :admin_statistics, only: [:index]
    resources :generations , only: [:index, :show, :update] 
    resources :statistics, only: [:show]
    resources :subscription_plans, only: [:index] do 
      collection do
        post :validate_discount
      end
    end
    resources :subscriptions do
      collection do
        post :cancel
        post :assign_free_trial
        get :current_subscription
      end
    end
    resources :users do 
      collection do
        get :show_current_user
        post :edit_current_user
      end
    end
    resources :projects do
      collection do
        post :assign_team_members
      end
    end
    resources :clients 
    resources :tags
    resources :integrations do
      collection do
        post :assign_client
        post :remove_client
        post :assign_main_client
        put :save_url
        get :show_url
      end
    end
  end

  namespace :integrations do
    resources :salla, only: [] do
      resources :products, module: 'salla' do
        collection { post :bulk_update_images }
        member do
          patch :update_image 
        end
      end
    end
  end
  namespace :api do
    resources :open_ai do
      collection do
        # post :validate_tokens
        post :generate_background
        post :reset_generation
        post :generate_batch_articles
        post :generate_batch
      end
    end
    resources :batch_groups, only: [:show]
  end

  namespace :integrations do
    namespace :salla do
      resources :webhooks, only: [] do
        collection { post :notifications }
      end
      resources :collections, only: [] do
        collection do
          put :bulk_update
        end
      end
      resources :products, only: [] do
        collection do
          put :bulk_update
        end
      end
    end
    namespace :shopify do
      resources :products, only: [] do
        collection do
          put :bulk_update
          get :fetch_supported_locales
          put :update_locale
          put :bulk_update_locale
        end
      end
      resources :collections, only: [] do
        collection do
          put :bulk_update
        end
      end
      resources :articles, only: [] do
        collection do
          put :bulk_update
        end
      end
      resources :media, only: [] do
        collection do
          put :bulk_update
        end
      end
    end

    namespace :wordpress do
      resources :products, only: [] do
        collection do
          put :bulk_update
        end
      end
      resources :collections, only: [] do
        collection do
          put :bulk_update
        end
      end
      resources :media, only: [] do
        collection do
          put :bulk_update
        end
      end
    end
  end
end

