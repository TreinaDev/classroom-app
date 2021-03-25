Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  devise_for :customers, controllers: {
    registrations: 'customers/registrations'
  }

  resources :users, only: %i[show]

  resources :video_classes, only: %i[new create show]
end
