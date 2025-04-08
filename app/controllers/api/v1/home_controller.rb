module Api
  module V1
    class HomeController < ApplicationController
      def index
        render json: { message: "API está funcionando!" }
      end
    end
  end
end
