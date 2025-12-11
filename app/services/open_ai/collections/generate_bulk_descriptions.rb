module OpenAi::Collections
  class GenerateBulkDescriptions < OpenAi::Generate
    include Interactor
    GENERATION_USED = 2

    def self.calculate_tokens(params)
      params[:collections].count.to_i * 2
    end

    private
    def prompt
      # params = {
      #   number_of_collections: "4",
      #   collections: [{"id": "408707268867","title": "summer collection"},{"id": "408707301635","title": "Winter Collection"}, {"id": "40870730122635","title": "Winter Hat"}, {"id": "4087073016322","title": "Winter Hat"}],
      #   language: "Arabic",
      #   include_keywords: "winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold",
      #   avoid_keywords: "summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot"
      # }
      "number of collections: #{params[:number_of_collections]}
      selected_collections = #{params[:collections]}
      Write the collections descriptions for these collections [selected_collections],#{include_existing_description}, ensure it's easily scannable with 1-headings,2- concise paragraphs and 3- bullet points, length range 200-300 characters for all collections
      generate only one description option per selected collection,
      Add these keywords [#{params[:include_keywords]}], avoid [#{params[:avoid_keywords]}].
      Use #{params[:language]} Language.
      Generate the description in HTML format.
      return the output as json schema  of collections
      follow this schema
      {
        'collections': [
          {'id': id of the collection, 'description': GENERATED_COLLECTION_DESCRIPTION}
        ]
      }
      "
    end

    def field
      "collection_description"
    end

    def count
      params[:collections].count || 1
    end

    def include_existing_description
      return "" unless attribute[:collection_description].present?
      return "" unless params[:use_exisiting_description].present?
      "take the main benefits and features in the existing description #{attribute[:collection_description]}"
    end
  end
end