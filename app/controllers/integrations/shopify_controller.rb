class Integrations::ShopifyController < ApplicationController
  before_action :authenticate_user!
    def install
      url = "https://#{params[:shop]}.myshopify.com/admin/oauth/authorize"
      scope = "read_products,read_content,read_product_listings,write_products,write_content"
      auth_url = Integrations::Install.call(api_key: ENV["SHOPIFY_API_KEY"], redirect_uri: ENV["SHOPIFY_REDIRECT_URI"], auth_token: request.headers['Authorization'], url: url, scope: scope,client_id: params[:client_id], other_params: "&grant_options[]=offline_access")
      render json: {url: auth_url.url}
    end
  end