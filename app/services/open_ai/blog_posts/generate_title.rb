module OpenAi::BlogPosts
  class GenerateTitle < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    private
    def prompt
      # params = {
      #   topic: 'The Future of Retail: Adapting to Changing Consumer Behavior and Technology Trends',
      #   language: "Arabic"
      # }
      "Generate a compelling h1 title from the [#{params[:topic]}], Insert high search volume keywords in the first 50 characters and make it 70 characters max.
      Use #{params[:language]} Language
      return the output as json schema  of products
      follow this schema
      {
        'title': GENERATED_TITLE
        
      }
      "
    end

    def field
      "article_title"
    end

  end
end