class Integrations::Wordpress::ProductsController< ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::WordPress::FetchProducts.call(user: current_user, wordpress_id: params[:wordpress_id], per_page: params[:per_page], page: params[:page], search: params[:search])
    if result.success?
      serialized_products = result.products.map do |product|
        WordPress::ProductSerializer.new(Hashie::Mash.new(product), root: false).as_json
      end
      render(json: { products: serialized_products, pagination: WordPressPaginationHelper::pagination(result.pagination)})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def show
    result = Integrations::WordPress::ShowProduct.call(user: current_user, wordpress_id: params[:wordpress_id], id: params[:id])
    if result.success?
      render(json: { product: result.product})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def update
    result = Integrations::WordPress::UpdateProduct.call(user: current_user, wordpress_id: params[:wordpress_id], params: product_params)
    if result.success?
      render(json: { response: result.product})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def bulk_update
    result=Integrations::WordPress::BulkUpdateProducts.call(user: current_user, wordpress_id: params[:wordpress_id], params: bulk_update_params)
    if result.success?
      render(json: { response: result.products})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end
  
  private 

  def product_params
    params.permit(:id, :title, :description, :sku, :regular_price, :search, :per_page, :page, seo: [:seo_title, :seo_description, :seo_url])
  end

  def bulk_update_params
    params.permit(products: [:id, :title, :description, :sku, :regular_price, seo: [:seo_title, :seo_description, :seo_url]])
  end
end
