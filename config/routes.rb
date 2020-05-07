Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' ,sessions: 'users/sessions' }
  root 'static_pages#home'
  get 'static_pages/home'
  get '/conversations/:id',       to: 'conversations#show'
  get '/users/:id',               to: 'users#show', as: :user
  get '/users',                   to: 'users#index'
  get '/friends',                 to: 'users#friends'
  get '/friend_requests',         to: 'users#friend_requests'
  post 'users/:id',               to: 'friendships#create'
  patch 'users/:id',              to: 'friendships#update'
  resources :friendships
  resources :posts, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
