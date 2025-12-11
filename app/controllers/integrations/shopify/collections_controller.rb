class Integrations::Shopify::CollectionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    result = Integrations::Shopify::FetchCollections.call(user: current_user, params: params)
    if result.success?
      serialized_collections = result.collections.map do |collection_item|
        collection = collection_item["node"] 
        ::Shopify::CollectionSerializer.new(Hashie::Mash.new(collection), root: false).as_json
      end
      render(json: { collections: serialized_collections, pagination: result.pagination })
    else
      render(json: { errors: result.error }, status: :unprocessable_entity)
    end
  end

  def show
    result = Integrations::Shopify::FetchCollection.call(user: current_user, params: params)
    if result.success?
      serialized_collection = ::Shopify::CollectionSerializer.new(Hashie::Mash.new(result.collection), root: false).as_json
      render(json: { collection: serialized_collection })
    else
      render(json: { errors: result.error }, status: :unprocessable_entity)
    end
  end

  def create
  end

  def update
    result = Integrations::Shopify::UpdateCollection.call(user: current_user, params: params, collection_params: collection_params)

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def bulk_update
    result = Integrations::Shopify::BulkUpdate::Organizers::Collections.call(user: current_user, params: batch_collections_params, shopify_id: params[:shopify_id])
    if result.success?
      render json: {}, status: :ok
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end
  private

  def collection_params
    params.require(:collection).permit(:id, :descriptionHtml, :handle, image: [:altText, :id],
      seo: [:description, :title])
  end

  def batch_collections_params
    params.require(:collections).permit(batch: [input: [:id, :handle, :descriptionHtml, image: [:altText, :id], seo: [:title, :description]]])
  end
end
