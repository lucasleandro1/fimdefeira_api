module Api
  module V1
    class TicketsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_client!, only: [ :create ]

      def index
        user = current_client || current_supermarket
        result = TicketManager::List.new(user).call

        if result[:success]
          render json: result[:resources].as_json(include: {
            client: { only: [ :id, :name, :email ] },
            ticket_items: {
              include: {
                post: {
                  include: {
                    product: { only: [ :name, :price ], methods: [ :photo_url ] }
                  }
                }
              }
            }
          }), status: :ok
        else
          render json: { error: result[:error_message] }, status: :unauthorized
        end
      end

      def show
        user = current_client || current_supermarket
        result = TicketManager::Finder.new(user, params[:id]).call

        if result[:success]
          ticket = result[:resource]
          ticket.destroy_if_expired
          render json: ticket.as_json(include: {
            ticket_items: {
              include: {
                post: {
                  include: {
                    product: { only: [ :name, :price ], methods: [ :photo_url ] }
                  }
                }
              }
            }
          })
        else
          render json: { error: result[:error_message] }, status: :forbidden
        end
      end


      def create
        service = TicketManager::Creator.new(current_client, ticket_params, ticket_items_params)
        result = service.call

        if result[:success]
          render json: result[:resources], status: :created, include: {
            ticket_items: { include: { post: { include: { product: { only: [ :name, :price ] } } } } } }
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      def validate
        user = current_supermarket
        return render json: { error: "Apenas supermercados podem validar tickets." }, status: :unauthorized unless user

        ticket = Ticket.find(params[:id])

        if ticket.supermarket_id != user.id
          return render json: { error: "Ticket não pertence ao seu supermercado." }, status: :forbidden
        end

        if ticket.entregue?
          return render json: { error: "Ticket já foi validado." }, status: :unprocessable_entity
        end

        ticket.update!(status: :entregue)
        render json: { message: "Ticket validado com sucesso.", ticket_id: ticket.id }, status: :ok
      end

      private

      def ticket_params
        params.require(:ticket).permit(:total_price)
      end

      def ticket_items_params
        params.require(:ticket_items).map do |item|
          item.permit(:post_id, :quantity)
        end
      end
    end
  end
end
