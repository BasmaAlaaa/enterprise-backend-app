module OpenAi::Batch::Products
  class GenerateDescriptionsPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private

    def prompt_content(attribute)
      "Create  an engaging, readable #{params[:text_length]} description for this product #{attribute[:title]},#{include_existing_description(attribute)} emphasizing these points:
      Make sure to mention different product variants in the description.
      Use Keywords: [#{params[:include_keywords]}]; avoid [#{params[:avoid_keywords]}],
      Tone: [#{params[:tone]}], Highlight product features and benefits with #{params[:bullet_points]}, #{params[:cta]}.
      Set #{params[:creativity_level]} writing creativity, generate #{params[:results_count]} option/s.
      Generate the description in HTML format.
      Use #{params[:language]} Language."
    end

    def custom_id(attribute)
      "description-#{attribute[:id]}"
    end

    def field
      "product_description"
    end

    def generation_used
      2
    end

    def include_existing_description(attribute)
      return "" if attribute[:product_description].blank?
      return "" if params[:use_exisiting_description].blank?
      "take the main benefits and features in the existing description: #{attribute[:product_description]}"
    end
  end
end