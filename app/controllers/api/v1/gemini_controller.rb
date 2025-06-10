module Api
  module V1
    class GeminiController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!

      def generate_content
        image_file = params.require(:image)

        service = GeminiService.new(image_file)
        result = service.extract_product_data

        if result.nil?
          render json: { error: "Não foi possível extrair os dados da imagem" }, status: :unprocessable_entity
        else
          render json: result, status: :ok
        end
      rescue => e
        Rails.logger.error "[GeminiController] Erro: #{e.message}"
        render json: { error: "Erro interno no servidor: #{e.message}" }, status: :internal_server_error
      end
    end
  end
end
