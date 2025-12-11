module OpenAi::Batch::Products
  class GenerateSeoDescriptionsPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private

    def prompt_content(attribute)
      "Create a readable 170 chars seo meta description for *#{attribute[:title]} from *#{attribute[:product_description]}*, embed product related high search volume keywords in the first 80 chars in the description.
      Use #{params[:language]} Language."
    end

    def custom_id(attribute)
      "seo_description-#{attribute[:id]}"
    end

    def field
      "product_seo"
    end

    def generation_used
      1
    end
  end
end