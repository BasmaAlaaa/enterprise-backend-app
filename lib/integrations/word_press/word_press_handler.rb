module Integrations
  module WordPress
    class WordPressHandler
    include HTTParty

      def initialize(integration)
        @integration = integration
        base_domain = "https://#{@integration.domain}"
        self.class.base_uri base_domain
      end

      def install(domain, token)
        body = { domain: domain }
        options = { 
          body: body.to_json, 
          headers: { 
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{token}"
          }
        }
        handle_request(:post, "/wp-json/integrations/wordpress/install", options)
      end

      def fetch_products(per_page, page, search)
        query_params = { page: page, per_page: per_page, search: search }
        options = { query: query_params, headers: bearer_headers }
        handle_request(:get, "/wp-json/scribe/v1/products" ,options)
      end

      def fetch_posts(per_page, page, search)
        query_params = { page: page, per_page: per_page, search: search}
        options = { query: query_params, headers: bearer_headers }
        handle_request(:get, "/wp-json/scribe/v1/blogs" ,options)
      end

      def fetch_categories(per_page, page, search)
        query_params = { page: page, per_page: per_page, search: search}
        options = { query: query_params, headers: bearer_headers }
        handle_request(:get, "/wp-json/scribe/v1/collections" ,options)
      end

      def fetch_media(per_page, page)
        query_params = { page: page, per_page: per_page }
        options = { query: query_params, headers: bearer_headers }
        handle_request(:get, "/wp-json/scribe/v1/media" ,options)
      end

      def update_product(params)
        handle_request(:put, "/wp-json/scribe/v1/update/product", body: params.to_json, headers: update_bearer_headers)
      end

      def update_category(params)
        handle_request(:put, "/wp-json/scribe/v1/update/collection", body: params.to_json, headers: update_bearer_headers)
      end

      def update_post(params)
        handle_request(:post, "/wp-json/scribe/v1/update/blog", body: params.to_json, headers: update_bearer_headers)
      end

      def update_media(params)
        handle_request(:post, "/wp-json/scribe/v1/update/media", body: params.to_json, headers: update_bearer_headers)
      end

      def bulk_update_media(params)
        handle_request(:post, "/wp-json/scribe/v1/update/media/bulk", body: params.to_json, headers: update_bearer_headers)
      end

      def bulk_update_products(params)
        handle_request(:post, "/wp-json/scribe/v1/update/products/bulk", body: params.to_json, headers: update_bearer_headers)
      end

      def bulk_update_collections(params)
        handle_request(:post, "/wp-json/scribe/v1/update/collections/bulk", body: params.to_json, headers: update_bearer_headers)
      end

      def show_product(id)
        handle_request(:get,"/wp-json/scribe/v1/products/#{id}" ,headers: bearer_headers)
      end

      def show_media(id)
        handle_request(:get,"/wp-json/scribe/v1/media/#{id}" ,headers: bearer_headers)
      end

      def show_category(id)
        handle_request(:get,"/wp-json/scribe/v1/collections/#{id}" ,headers: bearer_headers)
      end

      def show_post(id)
        handle_request(:get,"/wp-json/scribe/v1/blogs/#{id}" ,headers: bearer_headers)
      end

      def create_post(params)
        handle_request(:post, "/wp-json/scribe/v1/create/blog", body: params.to_json, headers: update_bearer_headers)
      end

      private

      def handle_request(method, path, options={})
        response = self.class.send(method, path, options)
        if response.success?
          JSON.parse(response.body)
        else
          { error: "Request failed with status #{response.code}: #{response.body}" }
        end
      end

      def bearer_headers
        { 'Authorization' => "Bearer #{@integration.token}" }
      end

      def update_bearer_headers
        { 'Authorization' => "Bearer #{@integration.token}", 'Content-Type' => 'application/json' }
      end
    end
  end 
end

