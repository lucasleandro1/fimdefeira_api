Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resource :user, only: [ :show, :update ]
    end
  end
end
