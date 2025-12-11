class Integrations::Shopify::MediaController < ApplicationController
  before_action :authenticate_user!
  
  def index
   result = Integrations::Shopify::FetchMedia.call(user: current_user, params: params)
    if result.success?
      serialized_media = result.files.map do |file|
      media = file["node"] 
      ::Shopify::MediaSerializer.new(Hashie::Mash.new(media), root: false).as_json
      end
      render json: { media: serialized_media, page_info: result.page_info }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def show
    result = Integrations::Shopify::FetchMediaImage.call(user: current_user, params: params)
    if result.success?
      serialized_media = ::Shopify::MediaSerializer.new(Hashie::Mash.new(result.media), root: false).as_json
      render json: { media: serialized_media }
    else
      render json: { errors: result.errors }, status: :not_found
    end
  end

  def create
  end

  def bulk_update
    result = Integrations::Shopify::BulkUpdateMedia.call(
      user: current_user,
      params: params,
      media_params: media_params
    )

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.errors }, status: :not_found
    end
  end


  private

  def media_params
    params.require(:media).permit(files: [:id, :alt])
  end
end
