module OpenAi::BlogPosts
  class GenerateTitles < OpenAi::Generate
    include Interactor
    GENERATION_USED = 2

    private
    def prompt
      "Generate a compelling h1 title for each one of this topics from the [#{params[:topics]}], make sure it is only one title for each topic. Insert high search volume keywords in each title within the first 50 characters and make it 70 characters max.
      Use #{params[:language]} Language
      return the output as json schema  of articles
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