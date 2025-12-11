class Integrations::Salla::ProductsController< ApplicationController
    before_action :authenticate_user!

    def index
      result = Integrations::Salla::FetchProducts.call(user: current_user,salla_id: params[:salla_id],page: params[:page],per_page: params[:per_page],keyword: params[:search])
  
      if result.success?
        render json: { products: result.products, pagination: result.pagination_info }, status: :ok
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end

    def create  
      result = Integrations::Salla::CreateProduct.call(user: current_user, salla_id: params[:salla_id], product_details: product_params)
  
      if result.success?
        render json: { product: result.response }, status: :created
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end

    def show
      result = Integrations::Salla::FetchProduct.call(user: current_user, salla_id: params[:salla_id], product_id: params[:id])
      if result
        render json: { product: Salla::ProductSerializer.new(Hashie::Mash.new(result.product["data"]), root: false).as_json }, status: :ok
      else
        render json: { errors: result.errors }, status: :not_found
      end
    end

    def update
      result = Integrations::Salla::UpdateProduct.call(
        user: current_user, 
        salla_id: params[:salla_id], 
        product_id: params[:id], 
        product_details: product_params
      )
  
      if result.success?
        render json: { message: "Product updated successfully", product: result.product }, status: :ok
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end

    def bulk_update
      result = Integrations::Salla::BulkUpdateProduct.call(
        user: current_user,
        salla_id: params[:salla_id],
        products: products_params[:products]
      )
    
      if result.success?
        render json: { message: "Products updated successfully", updated_products: result.updated_products }, status: :ok
      else
        render json: { message: "Some products failed to update", errors: result.errors }, status: :unprocessable_entity
      end
    end

    def update_image
      image_details = { image_url: params[:image_url], alt: params[:alt]}
      result = Integrations::Salla::UpdateProductImage.call(
        user: current_user,
        salla_id: params[:salla_id],
        image_id: params[:image_id],
        image_details: image_details
      )
      if result.success?
        render json: { message: "Product image updated successfully", product: result.product }, status: :ok
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end

    def bulk_update_images
      failed_images = []
      params[:images]&.each do |image|
        image_details = { image_url: image[:image_url], alt: image[:alt]}
        result = Integrations::Salla::UpdateProductImage.call(
          user: current_user,
          salla_id: params[:salla_id],
          image_id: image[:image_id],
          image_details: image_details
        )

        failed_images << {id: image[:image_id], errors: result.errors} unless result.success?
      end
        render json: { message: "Product images updated successfully", failed_images: failed_images }, status: :ok
    end

    private
  
    def product_params # only name , price and product type are required ,product type must be one of these values: 'product', 'service', 'group_products', 'codes', 'digital', 'food', and 'donating'
      params.permit(:name, :price, :description, :alt, :metadata_title, :metadata_description, :metadata_url, :image_id, :image_url)
    end

    def products_params
      params.permit(products: [:product_id, product_details: {}])
    end

end