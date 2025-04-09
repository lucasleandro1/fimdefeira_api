Rails.application.routes.draw do
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
    end
  end
end
