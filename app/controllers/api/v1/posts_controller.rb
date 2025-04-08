module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :ensure_supermarket!

      def create
        result = PostManager::Creator.new(current_user, post_params).call

        if result[:success]
          render json: result[:resource], status: :created
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def update
        update_service = PostManager::Updater.new(params[:id], post_params)
        result = update_service.call
        if result[:success]
          render json: result[:message], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:post).permit(:text, :product_id)
      end

      def ensure_supermarket!
        unless current_user.supermarket?
          render json: { error: "Only supermarkets can make this action." }, status: :forbidden
        end
      end
    end
  end
end
