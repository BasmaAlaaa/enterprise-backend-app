module OpenAi::Batch
  class Organizers::RetrieveBatch
    include Interactor::Organizer
    organize RetrieveBatchResults, ProcessBatchResults
  end
end
