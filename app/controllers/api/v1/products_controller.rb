module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!

      def index
        branch_id = params[:branch_id]

        if branch_id.blank?
          return render json: { error: "branch_id param is required" }, status: :bad_request
        end

        branch = current_supermarket.branches.find_by(id: branch_id)

        if branch.nil?
          return render json: { error: "Branch not found or does not belong to this supermarket" }, status: :not_found
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
        branch = current_supermarket.branches.find_by(id: product_params[:branch_id])
        return render json: { error: "Branch not found" }, status: :not_found if branch.nil?

        result = ProductManager::Creator.new(current_supermarket, branch, product_params).call

        if result[:success]
          product = result[:resource]
          if product.photo.attached?
            analyze_and_update_with_gemini(product)
          end
          render json: product_with_photo(product), status: :created
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def update
        branch = current_supermarket.branches.find_by(id: product_params[:branch_id])

        if branch.nil?
          render json: { error: "Branch not found" }, status: :unprocessable_entity
          return
        end

        update_service = ProductManager::Updater.new(params[:id], product_params, current_supermarket, branch)
        result = update_service.call

        if result[:success]
          render json: result[:message], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def show
        branch = current_supermarket.branches.find_by(id: params[:branch_id])

        if branch.nil?
          render json: { error: "Branch not found" }, status: :unprocessable_entity
          return
        end

        instance_finder = ProductManager::Finder.new(params[:id], current_supermarket, branch)
        result = instance_finder.call

        if result[:success]
          @product = result[:resources]
          render json: product_with_photo(@product)
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def destroy
        branch = current_supermarket.branches.find_by(id: params[:branch_id])

        if branch.nil?
          render json: { error: "Branch not found" }, status: :unprocessable_entity
          return
        end

        destroy_service = ProductManager::Destroyer.new(params[:id], current_supermarket, branch)
        result = destroy_service.call

        if result[:success]
          render json: result[:messages], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private

      def analyze_and_update_with_gemini(product)
        service = GeminiService.new(product.photo)
        gemini_data = service.extract_product_data

        Rails.logger.info "Gemini Data: #{gemini_data.inspect}"

        if gemini_data
          product.update(gemini_data)
        else
          Rails.logger.warn "=> Análise da Gemini para o produto ##{product.id} falhou ou não retornou dados."
        end
      rescue => e
        Rails.logger.error "=> ERRO INESPERADO durante a análise da Gemini para o produto ##{product.id}: #{e.message}"
      end

      def product_with_photo(product)
        return {} if product.nil?

        product.as_json.merge(
          photo_url: product.photo.attached? ? url_for(product.photo) : nil
        )
      end

      def product_params
        params.require(:product).permit(:name, :description, :expiration_date, :price, :stock_quantity, :active, :photo, :branch_id)
      end
    end
  end
end
