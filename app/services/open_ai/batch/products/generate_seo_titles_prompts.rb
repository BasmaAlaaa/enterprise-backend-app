module OpenAi::Batch::Products
  class GenerateSeoTitlesPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private

    def prompt_content(attribute)
      "Create a catchy seo meta title for #{attribute[:title]}, max 60 chars.
      Use #{params[:language]} Language."
    end

    def custom_id(attribute)
      "seo_title-#{attribute[:id]}"
    end

    def field
      "product_seo"
    end

    def generation_used
      1
    end
  end
end