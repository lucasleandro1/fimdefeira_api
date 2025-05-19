Rails.application.routes.draw do
root to: "api/v1/home#index"
  namespace :api do
    namespace :v1 do
      devise_for :supermarkets
      devise_for :clients
      resources :products
      resources :posts
      resources :branches
      resources :tickets, only: [ :create, :index, :show ]
    end
  end
end
