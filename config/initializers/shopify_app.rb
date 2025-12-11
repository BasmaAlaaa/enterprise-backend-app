
ShopifyApp.configure do |config|
    config.application_name = "local-testing"
    config.api_key = ENV['SHOPIFY_API_KEY']
    config.secret = ENV['SHOPIFY_API_SECRET']
    config.scope = "read_orders, read_products" # Add any additional scopes your app requires
    config.embedded_app = false
  end