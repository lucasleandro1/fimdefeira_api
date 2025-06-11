module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authorize_access
      before_action :authenticate_supermarket!, only: [ :create, :update, :destroy ]

def index
  user = current_client || current_supermarket
  result = TicketManager::List.new(user).call

  if result[:success]
    tickets = result[:resources]

    tickets.each do |ticket|
      # Garanta que o branch foi carregado corretamente
      if ticket.branch.present? && ticket.expired?
        ticket.destroy_if_expired
      end
    end

    render json: tickets.as_json(include: {
      client: { only: [ :id, :name, :email ] },
      ticket_items: {
        include: {
          post: {
            include: {
              product: { only: [ :name, :price ] }
            }
          }
        }
      }
    }), status: :ok
  else
    render json: { error: result[:error_message] }, status: :unauthorized
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
        branch_id = params[:branch_id]

        if current_supermarket.present? && branch_id.blank?
          render json: { error_message: "branch_id é obrigatório para supermercados" }, status: :unprocessable_entity
          return
        end

        current_user = current_supermarket || current_client
        instance_finder = PostManager::Finder.new(params[:id], current_user, branch_id).call

        if instance_finder[:success]
          @post = instance_finder[:resources]

          if current_user.is_a?(Supermarket)
            branch = current_supermarket.branches.find_by(id: branch_id)

            if branch.nil? || @post.nil? || @post.branch_id != branch.id
              return render json: { error: "Unauthorized" }, status: :forbidden
            end
          end
          render json: @post.as_json(
            include: {
              product: { only: [ :name, :description, :expiration_date, :price, :stock_quantity ] },
              supermarket: { only: [ :email ] },
              branch: { only: [ :address, :telephone ] }
            }
          )
        else
          render json: instance_finder, status: :unprocessable_entity
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

      def destroy
        destroy_service = PostManager::Destroyer.new(params[:id])
        result = destroy_service.call
        if result[:success]
          render json: result[:messages], status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      end

      private

      def current_user
        current_supermarket || current_client
      end

      def authorize_access
        unless current_supermarket || current_client
          render json: { error: "Não autorizado" }, status: :unauthorized
        end
      end

      def post_params
        params.require(:post).permit(:text, :product_id, :branch_id)
      end
    end
  end
end
