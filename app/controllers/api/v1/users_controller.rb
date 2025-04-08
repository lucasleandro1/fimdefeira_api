module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def update
        updated_user = UserManager::Updater.call(current_user, params.fetch(:user, {}))
        render json: updated_user, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:name, :address, :telephone)
      end
    end
  end
end
