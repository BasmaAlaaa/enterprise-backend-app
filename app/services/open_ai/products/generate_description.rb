module OpenAi::Products
  class GenerateDescription < OpenAi::Generate
    include Interactor
    GENERATION_USED = 2

    private

    def prompt
      # params = {
      #   # klass = Products::GenerateDescription
      #   title: "green jacket",
      #   include_keywords: "Summer,Hot",
      #   avoid_keywords: "Winter,Cold",
      #   tone: "funny,friendly",
      #   text_length: '300',
      #   material: 'cotton',
      #   style: 'Casual',
      #   language: "Arabic",
      #   bullet_points: "Include Bullet Points",
      #   cta: 'Include Bold CTA',
      #   creativity_level: 'high',
      #   results_count: 3

      # }
      "Create  an engaging, readable #{params[:text_length]} description for this product #{params[:title]},#{include_existing_description} emphasizing these points:
      Make sure to mention different product variants in the description.
      Use Keywords: [#{params[:include_keywords]}]; avoid [#{params[:avoid_keywords]}],
      Tone: [#{params[:tone]}], Highlight product features and benefits with #{params[:bullet_points]}, #{params[:cta]}.
      Set #{params[:creativity_level]} writing creativity, generate #{params[:results_count]} option/s.
      Generate the description in HTML format.
      Use #{params[:language]} Language.

      return the output as json schema of products
      follow this schema
      {
        description: [ description option 1, description option 2, description option 3, ...etc]
      }"
    end

    def field
      "product_description"
    end

    def include_existing_description
      return "" if params[:product_description].blank?
      return "" if params[:use_exisiting_description].blank?
      "take the main benefits and features in the existing description #{params[:product_description]}"
    end
  end
end