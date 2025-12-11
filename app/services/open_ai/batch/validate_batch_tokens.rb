module OpenAi
  module Batch
    class ValidateBatchTokens
      include Interactor

      delegate :params, :integration, :fail!, to: :context
      def call
        fail!(errors: "You should subscribe to a plan first") if integration.subscription.blank?

        remaining_generations = integration.subscription.remaining_generations
        total_generations = calculate_total_generations(params)
        fail!(errors: "This request can take up to #{total_generations} credits") if remaining_generations < total_generations
      end

      private

      def calculate_total_generations(params)
        params[:classes].sum do |method|
          interactor_class = "OpenAi::Batch::#{method}".constantize
          tokens = interactor_class.new.calculate_tokens(params)
          tokens
        end
      end
    end
  end
end