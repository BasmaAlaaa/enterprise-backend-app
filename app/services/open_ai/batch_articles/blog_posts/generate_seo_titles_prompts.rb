module OpenAi::BatchArticles::BlogPosts
  class GenerateSeoTitlesPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private
    def prompt_content(attribute)
      "Create a catchy seo meta title for #{attribute[:title]}, max 60 chars.embed blog related high search volume keywords. Use #{params[:language]} Language"
    end

    def custom_id(attribute)
      "seo_title-#{attribute[:title]}"
    end

    def field
      "article_seo"
    end

    def generation_used
      1
    end
  end
end