class Api::IntegrationsController < Api::BaseController
  before_action :set_integration, only: [:show, :update, :destroy, :remove_client, :save_url, :show_url]
  before_action :authorize_integration, only: [:show, :edit, :update, :destroy]

  def index
    integrations = policy_scope(Integration)
    paginate(integrations)  
  end

  def show
    render json: @integration
  end

  def assign_client
    integration = Integration.find_by(integration_type: params[:integration_type], domain: params[:domain])
    if integration
      authorize integration 
      integration.client_id = params[:client_id]
      authorize integration
      integration.save
      render json: integration
    else 
      render json: {errors: "This #{params[:integration_type]} domain is not yet integrated"}
    end
  end

  def assign_main_client
    integration = Integration.find_by(domain: params[:domain] , token: params[:token])
    if integration
      authorize integration
     client = current_user.clients.find_by(name: 'Main')
     integration.update(client_id: client.id)
      render json: integration
    else
      render json: {errors: "This domain is not yet integrated"}
    end
  end

  def create
    @integration = current_user.integrations.new(integration_params)
    if @integration.save
      render json: @integration, status: :created
    else
      render json: @integration.errors, status: :unprocessable_entity
    end
  end

  def update
    if @integration.update(integration_params)
      render json: @integration
    else
      render json: @integration.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @integration.destroy
    head :no_content
  end

  def remove_client
    @integration.update(client_id: nil)
    render json: @integration
  end

  def save_url
    @integration.update(google_search_console_site: params[:google_search_console_site])
    if @integration.save
      render(json: {message: 'URL saved successfully'})
    else
      render(json: {error: 'Error saving URL'}, status: :unprocessable_entity)
    end
  end

  def show_url
    expired = @integration.google_access_token.nil? || @integration.google_expires_at < Time.now
    render(json: { google_search_console_site: @integration.google_search_console_site, expired: expired })
  end  


  private

  def set_integration
    @integration = Integration.find(params[:id])
  end

  def integration_params
    params.require(:integration).permit(:name)
  end

  def authorize_integration
    authorize @integration
  end
end