class Integrations::WordpressController < ApplicationController
  before_action :authenticate_user!, except: [:callback]

  def install
    integration = Integration.find_by(integration_type: 'wordpress', domain: params[:domain], token: params[:token])
    return render json: { message: "Integration not found" }, status: :unprocessable_entity unless integration
    client = current_user.clients.find(params[:client_id])
    if integration.update(client_id: client.id)
      render json: { message: "Success" }, status: :ok
    else
      render json: { errors: integration.errors }, status: :unprocessable_entity
    end
  end
end