module OpenAi::BatchArticles
  class Organizers::GenerateBatch
    include Interactor::Organizer
    include OpenAi::Batch
    organize ValidateBatchTokens, PreProcessingBatch, UploadFileToOpenAi, CreateBatch
  end
end
