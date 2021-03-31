Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  get :user, to: "users#panel", as: :user_root

  devise_for :customers, controllers: {
    registrations: 'customers/registrations'
  }

  resources :users, only: %i[ show ]
    
  resources :video_classes, only: %i[ new create show edit update ] do
    post "disable", on: :member
    post 'watch', on:  :member
  end
end
