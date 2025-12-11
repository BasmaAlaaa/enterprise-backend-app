class Integrations::Salla::CollectionsController< ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::Salla::FetchCollections.call(
      user: current_user,
      salla_id: params[:salla_id],
      page: params[:page],
      per_page: params[:per_page],
      keyword: params[:name]
    )

    if result.success?
      render json: { collections: result.collections, pagination: result.pagination_info }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end
  
  def create
    result = Integrations::Salla::CreateCollection.call(user: current_user, salla_id: params[:salla_id], category_details: category_params)
    if result.success?
      render json: { category: result.response }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def show
    result = Integrations::Salla::FetchCollection.call(user: current_user, salla_id: params[:salla_id], category_id: params[:id])
    if result.success?
      render json: { collection: Salla::CollectionSerializer.new(Hashie::Mash.new(result.category["data"]), root: false).as_json }, status: :ok
    else
      render json: { errors: result.errors }, status: :not_found
    end
  end

  def update
    result = Integrations::Salla::UpdateCollection.call(
      user: current_user, 
      salla_id: params[:salla_id], 
      category_id: params[:id], 
      category_details: category_params
    )
  
    if result.success?
      render json: { message: "Collection updated successfully", category: result.category }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def bulk_update
    result = Integrations::Salla::BulkUpdateCollection.call(
      user: current_user,
      salla_id: params[:salla_id],
      collections: collections_params[:collections]
    )
    
    if result.success?
      render json: { message: "Collections updated successfully", updated_collections: result.updated_collections }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.permit(:name, :parent_id, :sort_order, :status, :metadata_title, :metadata_description, :metadata_url)
  end
  def collections_params
    params.permit(collections: [:collection_id, collection_details: {}])
  end

end