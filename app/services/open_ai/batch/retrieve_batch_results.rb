module OpenAi
  module Batch
    class RetrieveBatchResults
      include Interactor

      delegate :entity, :fail!, to: :context

      def call
        batch_id = entity.batch_id
        client = OpenAI::Client.new
        batch = client.batches.retrieve(id: batch_id)
        context.status = batch["status"]
        context.request_counts = batch["request_counts"]
        if batch["status"] == "completed"
          context.output_response = client.files.content(id: batch["output_file_id"])
        elsif batch["status"] == "failed"
          fail!(error: "Batch failed with error: #{batch['error']}")
        end
      end
    end
  end
end
