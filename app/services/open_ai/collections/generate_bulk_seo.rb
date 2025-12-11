module OpenAi::Collections
  class GenerateBulkSeo < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    def self.calculate_tokens(params)
      params[:collections].count.to_i
    end

    private
    def prompt
      # params = {
      #   collections: "[{id: 1, title: green jacket, description: over size green jacket for winter}, {id: 2, title: red sunglasses, description: new collection sunglasses for summer}, {id: 3, title: yellow chemise, description: casual chemise for the late dates}, {id: 4, title: yellow Hat, description: casual chemise for the late dates}]",
      #   language: 'Arabic',
      #   collection_description: "Stay stylish and warm with our versatile green jacket collection. From classic cuts to trendy designs, our jackets are perfect for any occasion, offering both comfort and style.",
      # }
      "Selected_collections = #{params[:collections]}
      Create a catchy seo meta titles in bulk for *selected_collections*,
      max 60 chars.
      readable max 140 chars seo meta descriptions from *selected_collection_descriptions*,
      embed collection related high search volume keywords in the first 80 chars in the descriptions.
      Use #{params[:language]} Language
      
      return the output as json schema  of collections
      follow this schema
      {
        'collections': [
          {  
            'id': id of the collection,
            'seo_description': GENERATED_SEO_DESCRIPTION,
            'seo_title': GENERATED_SEO_TITLE
          }
        ]
        
      }
      "
    end

    def field
      "collection_seo"
    end

    def count
      params[:collections].count || 1
    end

  end
end