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
    resources :accounts,
              only: [ :new, :edit, :create, :index, :update, :show ]
    root "dashboard#index"
  end
end
