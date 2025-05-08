module Api
  module V1
    class BranchesController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!

      def index
        instance_list = BranchManager::List.new.call
        if instance_list[:success]
          @supermarkets = instance_list[:resources]
          render json: @supermarkets.as_json(
            include: {
              branches: {
                only: [ :address, :telephone ]
              }
            }
          )
        else
          render json: instance_list, status: :unprocessable_entity
        end
      end

      def create
        result = BranchManager::Creator.new(current_supermarket, branch_params).call

        if result[:success]
          render json: result[:resource], status: :created
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def update
        update_service = BranchManager::Updater.new(params[:id], branch_params)
        result = update_service.call
        if result[:success]
          render json: result[:message], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def show
        instance_finder = BranchManager::Finder.new(params[:id])
        result = instance_finder.call
        if result[:success]
          @branches = result[:resources]
          render json: @branches.as_json
        else
          render json: result, status: :unprocessable_entity
        end
      end

      def destroy
        destroy_service = BranchManager::Destroyer.new(params[:id])
        result = destroy_service.call
        if result[:success]
          render json: result[:messages], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private

      def current_supermarket
        @current_supermarket ||= Supermarket.find_by(id: current_devise_api_user.id)
      end

      def branch_params
        params.require(:branch).permit(:address, :telephone)
      end
    end
  end
end
