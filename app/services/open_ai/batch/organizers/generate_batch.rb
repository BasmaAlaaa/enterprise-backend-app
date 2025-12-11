module OpenAi::Batch
  class Organizers::GenerateBatch
    include Interactor::Organizer
    organize ValidateBatchTokens, PreProcessingBatch, UploadFileToOpenAi, CreateBatch
  end
end
