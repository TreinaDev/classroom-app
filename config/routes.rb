Rails.application.routes.draw do
  devise_for :users
  devise_for :customers
  
  resources :users, only: %i[ show ]
  resources :video_classes, only: %i[ new create show ]
end
