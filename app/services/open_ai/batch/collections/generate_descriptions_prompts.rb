module OpenAi::Batch::Collections
  class GenerateDescriptionsPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private
    
    def prompt_content(attribute)
      "Write the product collection description for this product #{attribute[:title]}, #{include_existing_description(attribute)} ensure it's easily scannable with 1-headings,2- concise paragraphs and 3- bullet points, length range 200-300 characters.
      Add these keywords [#{params[:include_keywords]}], avoid [#{params[:avoid_keywords]}].
      Use #{params[:language]} Language.
      Generate the description in HTML format"
    end

    def custom_id(attribute)
      "description-#{attribute[:id]}"
    end

    def field
      "collection_description"
    end

    def generation_used
      2
    end

    def include_existing_description(attribute)
      return "" if attribute[:collection_description].blank?
      return "" if params[:use_exisiting_description].blank?
      "take the main benefits and features in the existing description: #{attribute[:collection_description]}"
    end
  end
end