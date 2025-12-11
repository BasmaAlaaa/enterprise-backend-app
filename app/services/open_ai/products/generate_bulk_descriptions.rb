module OpenAi::Products
  class GenerateBulkDescriptions < OpenAi::Generate
    include Interactor
    def self.calculate_tokens(params)
      params[:number_of_products].to_i * 2
    end
    private

    def prompt
      # params = {
      #   number_of_products: "4",
      #   products: "[{id: 1 , title: green jacket}, {id: 2, title: floral white top}, {id: 3, title, black jeans}, {id: 4, title, red socks}]",
      # include_keywords: "winter,cold,jan,dec,feb,march,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold,winter,cold",
      # avoid_keywords: "summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot,summer,hot",
    
      #   tone: "funny,friendly",
      #   creativity_level: "High"
      # }
      "number of products: #{params[:number_of_products]}
      products = [#{params[:products]}]
      Make sure to mention the selected product variants in the description.
      Create an engaging, readable 150 word descriptions,#{include_existing_description} emphasizing key points & attributes for [products]:
      Use Keywords: [#{params[:include_keywords]}]; avoid [#{params[:avoid_keywords]}]
      Tone: [#{params[:tone]}], use short paragraph then highlight product's benefits and features with #{params[:bullet_points]}, and add bold CTA at the end.
      Set creativity to [#{params[:creativity_level]}], generate only one title and one descriptions option per selected product
      Generate the description in HTML format.
      Use #{params[:language]} Language
      return the output as json schema  of products
      follow this schema
      {
        'products': [
          {'id': id of the product, 'description': VALUE}
        ]
      }"
    end

    def field
      "product_description"
    end

    def count
      params[:number_of_products] || 1
    end

    def include_existing_description
      return "" if attribute[:product_description].blank?
      return "" if params[:use_exisiting_description].blank?
      "take the main benefits and features in the existing description #{attribute[:product_description]}"
    end
  end
end