module OpenAi::BlogPosts
  class GenerateKeywords < OpenAi::Generate
    include Interactor
    GENERATION_USED = 1

    private
    def prompt
      "Given an array of modifiers #{params[:modifiers]}, generate 10 unique keywords for each modifier.
      Ensure that the keywords are relevant and distinct, capturing the essence of each modifier."
    end
    
    def field
      "article_topics"
    end
  end
end
