module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_devise_api_token!

      def authenticate_supermarket!
        if current_supermarket.nil?
          render json: { error: "Supermarket not authenticated" }, status: :unauthorized
        end
      end

      def authenticate_client!
        if current_client.nil?
          render json: { error: "Client not authenticated" }, status: :unauthorized
        end
      end

      def current_supermarket
        @current_supermarket ||= current_devise_api_user if current_devise_api_user.is_a?(Supermarket)
      end

      def current_client
        @current_client ||= current_devise_api_user if current_devise_api_user.is_a?(Client)
      end
    end
  end
end
