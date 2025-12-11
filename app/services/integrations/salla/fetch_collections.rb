module Integrations
  module Salla
    class FetchCollections
      include Interactor
      delegate :user, :salla_id, :page, :keyword, to: :context

      def call
        handler = SallaHandler.new(user, salla_id)
        response = handler.fetch_collections(page, keyword: keyword)

        if response
          context.collections = serialize_collections(response["data"])
          context.pagination_info = pagination(response["pagination"])
          context.integration = handler.get_integration
        else
          fail!(errors: response.body)
        end
      end

      private

      def serialize_collections(collections)
        collections.map do |collection|
          ::Salla::CollectionSerializer.new(Hashie::Mash.new(collection), root: false).as_json
        end
      end

      def pagination(pagination_data)
        current_page = pagination_data["currentPage"].to_i
        per_page = pagination_data["perPage"].to_i
        total_count = pagination_data["total"].to_i

        total_pages = (total_count.to_f / per_page).ceil
        {
          hasNextPage: current_page < total_pages,
          hasPreviousPage: current_page > 1,
          next: current_page < total_pages ? current_page + 1 : nil,
          current: current_page,
          totalPages: total_pages
        }
      end
    end
  end
end
