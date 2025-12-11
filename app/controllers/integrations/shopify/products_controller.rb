class Integrations::Shopify::ProductsController< ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::Shopify::FetchProducts.call(user: current_user,  params: params)
    if result.success?
      serialized_products = result.products['edges'].map do |edge|
        product = edge['node']
        ::Shopify::ProductSerializer.new(Hashie::Mash.new(product), root: false).as_json
      end
      render(json: { products: serialized_products, pagination: result.pagination })
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def show
    result = Integrations::Shopify::FetchProduct.call(user: current_user, params: params)
    if result.success?
      serialized_product = Shopify::ProductSerializer.new(Hashie::Mash.new(result.product), root: false).as_json
      render json: { product: serialized_product }, status: :ok
    else
      render(json: { error: result.error }, status: :not_found)
    end
  end

  def create
  end

  def update
    result = Integrations::Shopify::UpdateProduct.call(
      user: current_user,
      params: params,
      product_params: product_params
    )

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def bulk_update
    result = Integrations::Shopify::BulkUpdate::Organizers::Products.call(user: current_user, params: batch_products_params, shopify_id: params[:shopify_id])
    if result.success?
      render json: {}, status: :ok
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def update_locale
    result = Integrations::Shopify::Products::Organizers::UpdateLocaleProducts.call(user: current_user, params: params, id: params[:id])
    if result.success?
      render json: {}, status: :ok
    else
      render json: {errors: result.errors.map { |e| e["message"] }.join(", ")}, status: :unprocessable_entity
    end
  end

  def bulk_update_locale
    product_ids = batch_products_params[:batch].map { |item| item[:input][:id] }
    result = Integrations::Shopify::BulkUpdate::Organizers::LocaleProducts.call(user: current_user, product_ids: product_ids, params: batch_products_params, shopify_id: params[:shopify_id])
    if result.errors&.any?
      render json: { errors: result.errors.map { |e| e["message"] }.join(", ") }, status: :ok
    else
      render json: {}, status: :ok     
    end
  end

  def fetch_supported_locales
    result = Integrations::Shopify::FetchSupportedLocales.call(user: current_user, params: params)
    if result.success?
      render json: { locales: result.locales }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:id, :title, :body_html, :metafields_global_title_tag, :metafields_global_description_tag, :handle, images: [:id, :alt], seo: [:title, :description])
  end

  def batch_products_params
    params.require(:products).permit(batch: [input: [:id, :title, :handle, :descriptionHtml, :locale, :original_title, :original_descriptionHtml, seo: [:title, :description]]])
  end
end