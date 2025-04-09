Rails.application.routes.draw do
root to: "api/v1/home#index"
  namespace :api do
    namespace :v1 do
      devise_for :supermarkets,
                 path: "auth/supermarkets",
                 controllers: {
                   registrations: "api/v1/supermarkets/registrations"
                 }

      devise_for :clients,
                 path: "auth/clients",
                 controllers: {
                   registrations: "api/v1/clients/registrations"
                 }
      resources :products
    end
  end
end
