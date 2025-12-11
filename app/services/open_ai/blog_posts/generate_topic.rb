module OpenAi::BlogPosts
  class GenerateTopic < OpenAi::Generate
    include Interactor

    private
    def prompt
#       params = {
#         store_industry: "Retail",
#         store_description: 'Retail is the sale of goods and services to consumers, in contrast to wholesaling, which is sale to business or institutional customers',
#       }

      "Suggest this blog post topic based on the store's industry [#{params[:store_industry]}] and store description [#{params[:store_description]}], make sure to consider the most important questions and concerns to its target audience with high volume keywords topics
      return the output as json schema  of products
      follow this schema
      {
        'topic': GENERATED_TOPIC
        
      }
      "
    end

  end
end