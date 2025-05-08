module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authorize_access
      before_action :authenticate_supermarket!, only: [ :create, :update ]

      def index
        instance_list = PostManager::List.new.call
        if instance_list[:success]
          @posts = instance_list[:resources]
          render json: @posts.as_json(include:
          { product: { only: [ :name, :expiration_date, :price, :stock_quantity ] },
          supermarket: {
            only: [ :email ]
          } })
        else
          render json: instance_list, status: :unprocessable_entity
        end
      end

      def create
        result = PostManager::Creator.new(current_supermarket, post_params).call

        if result[:success]
          render json: result[:resource], status: :created
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def show
        instance_finder = PostManager::Finder.new(params[:id])
        result = instance_finder.call
        if result[:success]
          @post = result[:resources]
          render json: @post.as_json(include:
          { product: { only: [ :name, :description, :expiration_date, :price, :stock_quantity ] },
           supermarket: { only: [ :email ], include: { branches: { only: [ :address, :telephone ] } } } })
        else
          render json: result, status: :unprocessable_entity
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

      def authorize_access
        unless current_supermarket || current_client
          render json: { error: "Não autorizado" }, status: :unauthorized
        end
      end

      def current_supermarket
        @current_supermarket ||= current_devise_api_user if current_devise_api_user.is_a?(Supermarket)
      end

      def current_client
        @current_client ||= current_devise_api_user if current_devise_api_user.is_a?(Client)
      end

      def post_params
        params.require(:post).permit(:text, :product_id)
      end
    end
  end
end
