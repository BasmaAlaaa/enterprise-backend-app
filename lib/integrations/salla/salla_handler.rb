module Integrations
  module Salla
    class SallaHandler
    include HTTParty
    base_uri "https://api.salla.dev/admin/v2"

      def initialize(user, salla_id)
        @user = user
        @salla_id = salla_id
        @integration = user.integrations.find(@salla_id)
      end

      def fetch_product(product_id)
        handle_request(:get, "/products/#{product_id}")
      end

      def create_product(product_details)
        handle_request(:post, "/products", { body: product_details.to_json })
      end

      def update_product(product_id, product_details)
        handle_request(:put, "/products/#{product_id}", { body: product_details.to_json })
        status = { status: "sale" }
        handle_request(:post, "/products/#{product_id}/status", { body: status.to_json })
      end

      def fetch_products(page, per_page, keyword:nil)
        query_params = { page: page, per_page: per_page }
        query_params[:keyword] = keyword if keyword.present?
        handle_request(:get, "/products" , query: query_params)
      end

      def fetch_collection(collection_id)
        handle_request(:get, "/categories/#{collection_id}")
      end

      def fetch_collections(page, keyword:nil)
        query_params = { page: page }
        query_params[:keyword] = keyword if keyword.present?
        handle_request(:get, "/categories", query: query_params)
      end

      def create_collection(collection_details)
        handle_request(:post, "/categories", { body: collection_details.to_json })
      end

      def update_collection(collection_id, collection_details)
        handle_request(:put, "/categories/#{collection_id}", { body: collection_details.to_json })
      end

      def update_product_image(image_id, body)
        handle_request(:post, "/products/images/#{image_id}", { body: body.to_json })
      end
      
      def get_integration
        integration
      end

      private

      attr_reader :user, :salla_id, :integration

      def handle_request(method, path, options = {})
        response = self.class.send(method, path, headers: headers, **options)
        if response.success?
          response.parsed_response
        else
          fail!(response.body)
        end
      end

      def headers
        fail!("No salla store connected!") unless integration
        { 'Authorization' => "Bearer #{integration.token}",
          'Content-Type' => 'application/json' }
      end

      def integration
        @integration || fail!("No salla store connected!")
      end

      def fail!(message)
        raise StandardError.new(message)
      end
    end
  end
end