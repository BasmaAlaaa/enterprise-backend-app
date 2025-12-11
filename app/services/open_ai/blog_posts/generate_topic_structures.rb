module OpenAi::BlogPosts
  class GenerateTopicStructures < OpenAi::Generate
    include Interactor
    GENERATION_USED = 3

    private
    def prompt
      "given #{params[:main_theme]} as the main theme for the SEO blog campaign in #{params[:language]} language
      write 10 blog titles with modifiers.    
      return the output as json schema  of topics
      follow this schema
      {
       'topic_structure': GENERATED_TOPIC_STRUCTURE, 'modifier': [array of modifiers inside the topic structure]
      }"
    end

    def field
      "article_topics"
    end
  end
end