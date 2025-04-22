module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_supermarket!

      def authenticate_supermarket!
        if current_supermarket.nil?
          render json: { error: "Supermarket not authenticated" }, status: :unauthorized
        end
      end
    end
  end
end
