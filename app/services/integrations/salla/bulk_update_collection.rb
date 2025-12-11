module Integrations
  module Salla
    class BulkUpdateCollection
      include Interactor

      delegate :user, :salla_id, :collections, to: :context

      def call
        handler = SallaHandler.new(user, salla_id)
        context.failed_collections = []
        context.updated_collections = []
        
        collections.each do |collection|
          response = handler.update_collection(collection[:collection_id], collection[:collection_details])

          if response
            context.updated_collections << response
          else
            error_response = response ? response : {error: "Unknown error"}
            context.failed_collections << {collection_id: collection[:collection_id], error: error_response}
          end
        end

        if context.failed_collections.any?
          context.fail!(errors: context.failed_collections)
        end
      end
    end
  end
end
