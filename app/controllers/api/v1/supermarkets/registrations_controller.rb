module Api
  module V1
    module Supermarkets
      class RegistrationsController < ApplicationController
        before_action :authenticate_supermarket!

        def update
          if current_supermarket.update(supermarket_params)
            render json: { message: "Dados atualizados com sucesso", supermarket: current_supermarket }, status: :ok
          else
            render json: { errors: current_supermarket.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def supermarket_params
          params.require(:supermarket).permit(:name, :cnpj)
        end
      end
    end
  end
end
