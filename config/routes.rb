Rails.application.routes.draw do
  resources :users
  resources :posts
  resources :comments
  resources :sessions, only: %i[create]
  resources :claps, only: %i[create]
  root 'users#show'
  post 'users/login', to: 'users#login'
  post 'session/logout', to: 'sessions#destroy'
end
