module OpenAi::Collections
  class GenerateDescription < OpenAi::Generate
    include Interactor
    GENERATION_USED = 2

    private
    def prompt
      # params = {
      #   title: "green jacket",
      #   language: "Arabic",
      # include_keywords: "winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold",
      # avoid_keywords: "summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot"
    
      # }

      "Write the product collection description for this product #{params[:title]},#{include_existing_description} ensure it's easily scannable with 1-headings,2- concise paragraphs and 3- bullet points, length range 200-300 characters.
      Add these keywords [#{params[:include_keywords]}], avoid [#{params[:avoid_keywords]}].
      Use #{params[:language]} Language.
      Generate the description in HTML format.
      return the output as json schema  of products
      follow this schema
      {
        'description': GENERATED_COLLECTION_DESCRIPTION
        
      }
      "
    end

    def field
      "collection_description"
    end

    def include_existing_description
      return "" if params[:collection_description].blank?
      return "" if params[:use_exisiting_description].blank?
      "take the main benefits and features in the existing description #{params[:collection_description]}"
    end
  end
end