module OpenAi::BatchArticles::BlogPosts
  class GenerateTitlesPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private
    def prompt_content(attribute)
      "Generate a compelling h1 title from the [#{attribute[:topic]}], Insert high search volume keywords in the first 50 characters and make it 70 characters max.
      Use #{params[:language]} Language"
    end

    def custom_id(attribute)
      "titles-#{attribute[:title]}"
    end

    def field
      "article_title"
    end

    def generation_used
      1
    end
  end
end