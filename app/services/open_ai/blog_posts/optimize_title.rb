module OpenAi::BlogPosts
  class OptimizeTitle < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    private

    def prompt
      # params = {
      #   title: "Retail Trends: Adapting to Changing Consumer Behavior",
      # }
      "Generate an optimized compelling title from #{params[:title]}, Insert high search volume keywords and make it 70 characters max.

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