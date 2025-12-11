class Integrations::Wordpress::CollectionsController< ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::WordPress::FetchCategories.call(user: current_user, wordpress_id: params[:wordpress_id], per_page: params[:per_page], page: params[:page], search: params[:search])
    if result.success?
      serialized_collections = result.categories.map do |category|
        WordPress::CollectionSerializer.new(Hashie::Mash.new(category), root: false).as_json
      end
      render(json: { collections: serialized_collections, pagination: WordPressPaginationHelper::pagination(result.pagination)})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def show
    result = Integrations::WordPress::ShowCategory.call(user: current_user, wordpress_id: params[:wordpress_id], id: params[:id])
    if result.success?
      serialized_collection = WordPress::CollectionSerializer.new(Hashie::Mash.new(result.category), root: false).as_json
      render(json: { collection: serialized_collection})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def update
    result = Integrations::WordPress::UpdateCategory.call(user: current_user, wordpress_id: params[:wordpress_id], params: category_params)
    if result.success?
      render(json: { response: result.category})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def bulk_update
    result=Integrations::WordPress::BulkUpdateCategories.call(user: current_user, wordpress_id: params[:wordpress_id], params: bulk_update_params)
    if result.success?
      render(json: { response: result.collections})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  private 

  def category_params
    params.permit(:id, :title, :description, :search, :per_page, :page, seo: [:seo_title, :seo_description, :seo_url])
  end

  def bulk_update_params
    params.permit(collections: [:id, :title, :description, seo: [:seo_title, :seo_description, :seo_url]])
  end
end
