module OpenAi::Products
  class GenerateSeo < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1
    private

    def prompt
      # params = {
      #   # klass = Products::GenerateSeo
      #   title: "green jacket",
      #   language: 'Arabic',
      #   product_description: "Get ready to embrace the summer heat with our new line of **casual cotton** clothing! Made for those hot summer days, our collection features a range of comfortable and stylish options that will keep you cool and looking great"
      # }
      "Create a catchy seo meta title for #{params[:title]}, max 60 chars. for the title and for an engaging, readable max 140 chars seo meta description from [#{params[:product_description]}], embed product related high search volume keywords in the first 80 chars in the description.
      Use #{params[:language]} Language.

      return the output as json schema  of products
      follow this schema
      {
       'seo_description': GENERATED_SEO_DESCIRPTION, 'seo_title': GENERATED_SEO_TITLE
      }
      "
    end

    def field
      "product_seo"
    end

  end
end