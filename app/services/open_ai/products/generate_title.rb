module OpenAi::Products
  class GenerateTitle < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    private

    def prompt
      # params = {
      #   title: "green jacket",
      #   # store: 'from Rubix',
      #   language: "Arabic",
      # }
      "Create a catchy title for #{params[:title]} #{params[:store]}, following 'brand, product, attributes' format, max 60 chars.
      Use #{params[:language]} Language.
      return the output as json schema  of products
      follow this schema
      {
        'title': GENERATED_TITLE
        
      }
      "
    end

    def field
      "product_title"
    end

  end
end