Rails.application.routes.draw do
  root to: "api/v1/home#index"

  namespace :api do
    namespace :v1 do
      devise_for :users
    end
  end
end
