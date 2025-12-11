module OpenAi::Batch::Products
  class GenerateTitlesPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private

    def prompt_content(attribute)
      "Create a catchy title for #{attribute[:title]} #{include_store_name}, following 'brand, product, attributes' format, max 60 chars.
      Use #{params[:language]} Language."
    end

    def custom_id(attribute)
      "title-#{attribute[:id]}"
    end

    def include_store_name
      return "" unless params[:store].present?

      "Include #{params[:store]} in the generated title"
    end

    def field
      "product_title"
    end

    def generation_used
      1
    end
  end
end
