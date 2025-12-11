module OpenAi
  class ValidateTokens
    include Interactor

    delegate :max_tokens, :params, :integration, :fail!, to: :context
    def call
      subscription = integration&.subscription
      fail!(errors: "You should subscribe to a plan first") if subscription.blank?
      fail!(errors: "Please upgrade your plan to use this feature"
        ) if params[:classes].join(",").include?("BlogPosts") && !subscription.blog_post?

      remaining_generations = subscription.remaining_generations
      remaining_images = subscription.remaining_images
      total_words = 0
      total_images = 0
      params[:classes].each do |klass|
        next total_images = 1 if klass == "GenerateImage"
  
        total_words+= "OpenAi::#{klass}".constantize.calculate_tokens(params).to_i
      end
      fail!(errors: "This request can take up to #{total_words} credits") if remaining_generations < total_words
      fail!(errors: "You don't have enough image generations for this request") if remaining_images.to_i < total_images
      context.total_words = total_words
      context.total_images = total_images
    end

    private

    def prompt
      ""
    end
  end
end