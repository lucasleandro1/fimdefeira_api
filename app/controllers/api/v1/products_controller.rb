module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!

      def index
        instance_list = ProductManager::List.new.call
        if instance_list[:success]
          @products = instance_list[:resources]
          render json: @products.as_json
        else
          render json: instance_list, status: :unprocessable_entity
        end
      end

      def create
        result = ProductManager::Creator.new(current_supermarket, product_params).call

        if result[:success]
          render json: result[:resource], status: :created
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def update
        update_service = ProductManager::Updater.new(params[:id], product_params)
        result = update_service.call
        if result[:success]
          render json: result[:message], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def show
        instance_finder = ProductManager::Finder.new(params[:id])
        result = instance_finder.call
        if result[:success]
          @product = result[:resources]
          render json: @product.as_json
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def destroy
        destroy_service = ProductManager::Destroyer.new(params[:id])
        result = destroy_service.call
        if result[:success]
          render json: result[:messages], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private

      def product_params
        params.require(:product).permit(:name, :description, :expiration_date, :price, :stock_quantity, :active)
      end

      def current_supermarket
        @current_supermarket ||= Supermarket.find_by(id: current_devise_api_user.id)
      end
    end
  end
end
