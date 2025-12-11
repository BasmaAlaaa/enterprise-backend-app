module OpenAi::BatchArticles::BlogPosts
  class GenerateExcerptPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private
    def prompt_content(attribute)
      "Generate a concise, engaging excerpt from a blog post about **#{attribute[:content]}**.length range 100-300 characters.The excerpt should highlight the main theme, include a compelling question or statement to intrigue the reader, and end with a call-to-action encouraging further reading.Use #{params[:language]} Language"
    end

    def custom_id(attribute)
      "excerpt-#{attribute[:title]}"
    end

    def field
      "article_excerpt"
    end

    def generation_used
      3
    end
  end
end