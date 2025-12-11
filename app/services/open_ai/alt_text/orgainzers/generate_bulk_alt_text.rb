module OpenAi
  module AltText
    module Orgainzers
      class GenerateBulkAltText
      include Interactor::Organizer
      include Interactor::Transactionable

      GENERATION_USED = 2

    def self.calculate_tokens(params)
      return params[:old_content][:attributes].flatten.count * 2 if params[:alt_text_type] == "single"

      count = 0

      params[:old_content][:attributes].each { |record| count+= record[:images].count }
      2 * count
    end

    organize OpenAi::AltText::DataProcessing,
    OpenAi::GenerateAltText,
    OpenAi::AltText::PostProcessing
  end
end
end
end
