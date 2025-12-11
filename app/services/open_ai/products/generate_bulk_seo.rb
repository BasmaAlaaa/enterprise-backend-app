module OpenAi::Products
  class GenerateBulkSeo < OpenAi::Generate
    include Interactor
    def self.calculate_tokens(params)
      params[:number_of_products].to_i
    end

    private
    def prompt
      # params = {}
      # params[:products] = "products = [{id: 1 , title: green jacket}, {id: 2, title: floral white top}, {id: 3, title, black jeans}, {id: 4, title, Yellow jeans}]"
      # params[:language] = "Arabic"
      "selected_products = [#{params[:products]}]
      Create a catchy seo meta titles in bulk for [selected_products], max 60 chars.
      readable max 140 chars seo meta descriptions from [selected_products], embed product related high search volume keywords in the first 80 chars in the descriptions.
      Use #{params[:language]} Language
      
      return the output as json schema  of products
      follow this schema
      {
        'products': [
          {'id': id of the product, 'seo_description': GENERATED_SEO_DESCIRPTION, 'seo_title': GENERATED_SEO_TITLE}
        ]
      }"
      
    end

    def field
      "product_seo"
    end

    def count
      params[:number_of_products] || 1
    end
  end
end