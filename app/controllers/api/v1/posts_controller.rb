module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!

      def create
        result = PostManager::Creator.new(current_supermarket, post_params).call

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

      def current_supermarket
        @current_supermarket ||= Supermarket.find_by(id: current_devise_api_user.id)
      end

      def post_params
        params.require(:post).permit(:text, :product_id)
      end
    end
  end
end
