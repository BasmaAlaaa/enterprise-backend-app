module OpenAi::BatchArticles::BlogPosts
  class GenerateSeoDescriptionsPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private
    def prompt_content(attribute)
     "Create a catchy readable 170 chars seo meta description from #{attribute[:excerpt]},embed blog related high search volume keywords in the first 80 chars in the description. Use #{params[:language]} Language"
    end

    def custom_id(attribute)
      "seo_description-#{attribute[:title]}"
    end

    def field
      "article_seo"
    end

    def generation_used
      1
    end
  end
end