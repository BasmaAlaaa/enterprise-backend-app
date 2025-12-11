class Integrations::Wordpress::MediaController< ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::WordPress::FetchMedia.call(user: current_user, wordpress_id: params[:wordpress_id], per_page: params[:per_page], page: params[:page])
    if result.success?
      serialized_media = result.media.map do |media|
        WordPress::MediaSerializer.new(Hashie::Mash.new(media), root: false).as_json
      end
      render(json: { media: serialized_media, pagination: WordPressPaginationHelper::pagination(result.pagination)})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def show
    result = Integrations::WordPress::ShowMedia.call(user: current_user, wordpress_id: params[:wordpress_id], id: params[:id])
    if result.success?
      serialized_media = WordPress::MediaSerializer.new(Hashie::Mash.new(result.media), root: false).as_json
      render(json: { media: serialized_media})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end
 
  def update
    result = Integrations::WordPress::UpdateMedia.call(user: current_user, wordpress_id: params[:wordpress_id], params: media_params)
    if result.success?
      render(json: { response: result.media})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def bulk_update
    result=Integrations::WordPress::BulkUpdateMedia.call(user: current_user, wordpress_id: params[:wordpress_id], params: bulk_update_params)
    if result.success?
      render(json: { response: result.media})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  private

  def media_params
    params.permit(:id, :alt, :per_page, :page)
  end

  def bulk_update_params
    params.permit(media: [:id, :alt])
  end
end

 