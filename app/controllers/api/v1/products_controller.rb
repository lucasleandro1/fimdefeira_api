module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!

    def index
      branch = current_supermarket.branches.find_by(id: params[:branch_id])

      if branch.nil?
        render json: { error: "Branch not found" }, status: :unprocessable_entity
        return
      end

      instance_list = ProductManager::List.new(current_supermarket, branch).call

      if instance_list[:success]
        @products = instance_list[:resources].compact
        render json: @products.map { |product| product_with_photo(product) }
      else
        render json: instance_list, status: :unprocessable_entity
      end
    end


      def create
        result = ProductManager::Creator.new(current_supermarket, product_params).call

        if result[:success]
          render json: product_with_photo(result[:resource]), status: :created
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def update
        update_service = ProductManager::Updater.new(params[:id], product_params, current_supermarket)
        result = update_service.call
        if result[:success]
          render json: result[:message], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def show
        instance_finder = ProductManager::Finder.new(params[:id], current_supermarket)
        result = instance_finder.call
        if result[:success]
          @product = result[:resources]
          render json: product_with_photo(@product)
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def destroy
        destroy_service = ProductManager::Destroyer.new(params[:id], current_supermarket)
        result = destroy_service.call
        if result[:success]
          render json: result[:messages], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private

      def product_with_photo(product)
        return {} if product.nil?

        product.as_json.merge(
          photo_url: product.photo.attached? ? url_for(product.photo) : nil
        )
      end

      def product_params
        params.require(:product).permit(:name, :description, :expiration_date, :price, :stock_quantity, :active, :photo)
      end
    end
  end
end
