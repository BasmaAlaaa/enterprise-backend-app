class Api::ClientsController < Api::BaseController
  before_action :set_client, only: [:show, :update, :destroy]

  def index
    clients = policy_scope(Client)
    # @clients = @clients.by_integrations(params[:integrations]) if params[:integrations]
    clients = clients.by_name(params[:name]) if params[:name]
    paginate(clients)   
  end

  def show
    authorize @client # Calls ClientPolicy#show?
    render json: @client
  end

  def create
    @client = current_user.clients.new(client_params)
    authorize @client # Calls ClientPolicy#create?
    if @client.save
      render json: @client, status: :created
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @client # Calls ClientPolicy#update?

    if @client.update(client_params)
      render json: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @client # Calls ClientPolicy#destroy?
    @client.destroy
    head :no_content
  end


  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name)
  end
end
