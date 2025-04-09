class Api::V1::Clients::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:client).permit(:email, :password, :password_confirmation, :name, :address, :telephone)
  end

  def account_update_params
    sign_up_params
  end
end
