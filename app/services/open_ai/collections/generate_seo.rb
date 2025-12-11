module OpenAi::Collections
  class GenerateSeo < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    private
    def prompt
      # params = {
      #   language: "Arabic",
      #   title: 'green jacket',
      #   collection_description: "Stay stylish and warm with our versatile green jacket collection. From classic cuts to trendy designs, our jackets are perfect for any occasion, offering both comfort and style.",
      # }
      "Create a catchy seo meta title for #{params[:title]},
      max 60 chars.
      readable max 140 chars seo meta description from *#{params[:description]}*,
      embed product related high search volume keywords in the first 80 chars in the description.
      Use #{params[:language]} Language
      return the output as json schema of collections
      follow this schema
      {
        'seo_description': GENERATED_SEO_DESCRIPTION,
        'seo_title': GENERATED_SEO_TITLE
        
      }
      "
    end

    def field
      "collection_seo"
    end
  end
end