module GoogleAds
  class Organizers::GenerateKeywords
    include Interactor::Organizer
    include Interactor::Transactionable

    organize GoogleAds::BuildKeywordParams, GoogleAds::GenerateKeywordIdeas, GoogleAds::UpdateGeneration
  end
end