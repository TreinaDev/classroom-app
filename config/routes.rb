Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  get :user, to: "users#panel", as: :user_root

  devise_for :customers, controllers: {
    registrations: 'customers/registrations'
  }

  resources :customers, only: %i[ show ]

  resources :users, only: %i[show]

  resources :video_classes do
    get 'scheduled', on: :collection
    post 'watch', on: :member    
  end
end
