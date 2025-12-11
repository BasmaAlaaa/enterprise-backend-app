module OpenAi
  module BatchArticles
    class PreProcessingBatch
      include Interactor

      delegate :params, :integration, :fail!, to: :context

      def call
        results = params[:classes]&.each_with_object(prompts: '', errors: []) do |method_name, acc|
          interactor_class = "OpenAi::BatchArticles::#{method_name}".constantize
          result_context = interactor_class.call(params: params, integration: integration)
          if result_context.success?
            update_statistics(result_context.tokens,result_context.field)
            acc[:prompts] << result_context&.prompts.join("\n") << "\n"
          else
            fail!(errors: result_context.errors)
          end
        end
        context.prompts = results[:prompts].strip
      end

      private

      def update_statistics(tokens,field)
        count = params[:batch_data].size
        Statistics.where(integration_id: integration.id).update_all("#{field} = #{field} + #{count}")
        subscription = integration.subscription
        remaining_generations =  subscription.remaining_generations - tokens
        subscription.update_attribute(:remaining_generations, remaining_generations)
      end
    end
  end
end