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
    resources :banned_words
    resources :external_users
    resources :accounts,
              only: [ :new, :show, :edit, :create, :index, :update ] do
      resources :external_providers,
                only: [:new] do
        collection do
          get :authorize, as: :authorize
        end
      end
    end
    root "dashboard#index"
  end
end
