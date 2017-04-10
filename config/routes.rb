require 'sidekiq/web'
require 'sidekiq-scheduler'
require 'sidekiq-scheduler/web'
require 'superadmin_constraint'

Rails.application.routes.draw do
  devise_for :users,
             class_name: "Admin::User",
             controllers: {
               omniauth_callbacks: "admin/users/omniauth_callbacks"
             }
  devise_scope :user do
    get 'sign_in',
        to: 'devise/sessions#new',
        as: :new_user_session
    get 'sign_out',
        to: 'devise/sessions#destroy',
        as: :destroy_user_session
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  namespace :admin do
    resources :dashboard_users
    resources :banned_words
    resources :external_users do
      member do
        post :update_status
        post :analyse_latest_posts
      end
    end
    resources :accounts,
              only: [ :new, :show, :edit, :create, :index, :update ] do
      resources :external_providers,
                only: [:new] do
        collection do
          get :authorize, as: :authorize
        end
      end
      resources :external_posts,
                only: [] do
        member do
          post :repost, as: :repost
        end
      end
      resource :external_provider_registration,
               only: [:new, :show]
    end

    mount Sidekiq::Web => '/sidekiq', constraints: SuperadminConstraint.new

    root "dashboard#index"
  end
end
