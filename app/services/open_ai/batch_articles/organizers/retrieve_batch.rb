module OpenAi::BatchArticles
  class Organizers::RetrieveBatch
    include Interactor::Organizer
    include OpenAi::Batch
    organize RetrieveBatchResults, ProcessBatchResults
  end
end
