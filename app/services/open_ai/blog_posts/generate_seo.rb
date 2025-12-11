module OpenAi::BlogPosts
  class GenerateSeo < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    private

    def prompt
      # params = {
      #   language: "Arabic",
      #   title: "Retail Trends: Adapting to Changing Consumer Behavior",
      #   excerpt: "Discover the transformative power of creatine supplementation - from turbocharging muscle growth to fortifying brain health. Are you ready to unlock your peak performance? Dive into the world of creatine and elevate your fitness journey today!"
      # }
      "Create a catchy seo meta title for #{params[:title]}, max 60 chars.
      readable 140 chars seo meta description from #{params[:excerpt]},
      embed blog related high search volume keywords in the first 80 chars in the description.
      Use #{params[:language]} Language

      return the output as json schema  of products
      follow this schema
      {
        'seo_title': GENERATED_SEO_TITLE,
        'seo_description': GENERATED_SEO_DESCRIPTION
        
      }
      "
    end

    def field
      "article_seo"
    end

  end
end