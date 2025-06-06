Rails.application.routes.draw do
root to: "api/v1/home#index"
  namespace :api do
    namespace :v1 do
      devise_for :supermarkets, controllers: {
        registrations: "api/v1/supermarkets/registrations"
      }

      devise_for :clients, controllers: {
        registrations: "api/v1/clients/registrations"
      }
      resources :supermarkets, only: [ :index, :show ]
      resources :products
      resources :posts
      resources :branches
      resources :tickets, only: [ :create, :index, :show ] do
        member do
          patch :validate
        end
      end
    end
  end
end
