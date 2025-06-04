module Api
  module V1
    class SupermarketsController < ApplicationController
      def index
        supermarkets = Supermarket.includes(:posts).all

        render json: supermarkets, include: { posts: { only: [ :id, :text, :created_at, :updated_at ] } }, status: :ok
      end

      def show
        supermarket = Supermarket.includes(:posts).find_by(id: params[:id])

        if supermarket
          render json: supermarket, include: { posts: { only: [ :id, :text, :created_at, :updated_at ] } }, status: :ok
        else
          render json: { error: "Supermercado não encontrado" }, status: :not_found
        end
      end
    end
  end
end
