module Api
  module V1
    class GeminiController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :authenticate_supermarket!


      def generate_content
        image_file = params.require(:image)

        service = GeminiService.new(image_file)
        gemini_data = service.extract_product_data

        if gemini_data
          render json: gemini_data, status: :ok
        else
          render json: { error: "Falha na análise da imagem" }, status: :unprocessable_entity
        end
      end
    end
  end
end
