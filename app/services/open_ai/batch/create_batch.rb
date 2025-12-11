module OpenAi
  module Batch
    class CreateBatch
      include Interactor

      delegate :file_id, :entity, :fail!, to: :context

      def call
        client = OpenAI::Client.new
        response = client.batches.create(
          parameters: {
            input_file_id: file_id,
            endpoint: "/v1/chat/completions",
            completion_window: "24h"
          }
        )
        batch_id = response['id']
        entity.update(batch_id: batch_id)
      rescue => e
        fail!(error: "Error creating batch: #{e.message}")
      end
    end
  end
end
