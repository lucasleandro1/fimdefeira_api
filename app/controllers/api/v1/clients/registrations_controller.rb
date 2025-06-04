module Api
  module V1
    module Clients
      class RegistrationsController < ApplicationController
        before_action :authenticate_client!

        def update
          if current_client.update(client_params)
            render json: { message: "Dados atualizados com sucesso", client: current_client }, status: :ok
          else
            render json: { errors: current_client.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def client_params
          params.require(:client).permit(:name, :address, :telephone)
        end
      end
    end
  end
end
