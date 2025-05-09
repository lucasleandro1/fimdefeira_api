module Api
  module V1
    class TicketsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authorize_access
      before_action :authenticate_client!, only: [ :create ]

      def create
        service = TicketManager::Creator.new(current_client, ticket_params, ticket_items_params)
        result = service.call

        if result[:success]
          render json: result[:resource], status: :created, include: { ticket_items: { include: { product: { only: [ :name, :price ] } } } }
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private
      def ticket_params
        params.require(:ticket).permit(:total_price)
      end

      def ticket_items_params
        params.require(:ticket_items).map { |item| item.permit(:post_id, :quantity, :subtotal_price) }
      end

      def ticket_params
        params.require(:ticket).permit(ticket_items_attributes: [ :post_id, :quantity ])
      end
    end
  end
end
