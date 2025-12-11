module OpenAi::Products
  class GenerateBulkTitles < OpenAi::Generate
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
      Create enhanced catchy titles in bulk for [selected_products] from [#{params[:store]}], following 'brand, product, attributes' format, max 70 chars.
      Use [#{params[:language]}] Language.
      return the output as json schema  of products
      follow this schema
      {
        'products': [
          {'id': id of the product, 'title': THE GENERATED TITLE}
        ]
      }"
    end

    def field
      "product_title"
    end

    def count
      params[:number_of_products] || 1
    end

  end
end