Rails.application.routes.draw do
  #devise_for :users
  require "sidekiq/web"
  mount Sidekiq::Web => '/sidekiq'

  root to: 'pages#home'

  resources :ads, only: [:index, :show]
  resources :products, only: [:index, :show]
end
