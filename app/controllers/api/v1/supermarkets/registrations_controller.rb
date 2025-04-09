class Api::V1::Supermarkets::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      sign_up(resource_name, resource)

      encoder = Warden::JWTAuth::UserEncoder.new
      token, _payload = encoder.call(resource, :supermarket, nil)
      render json: {
        status: { code: 200, message: "Conta criada com sucesso." },
        data: resource,
        token: token
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Erro ao criar a conta.", errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:registration).permit(:email, :password, :password_confirmation, :name, :cnpj, :address, :telephone)
  end
end
