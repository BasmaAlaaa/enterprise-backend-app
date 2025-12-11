module OpenAi
  class Generate
    include Interactor

    delegate :max_tokens, :params, :integration, :fail!, to: :context
    GENERATION_USED = 1
    def self.calculate_tokens(params)
      "#{self}::GENERATION_USED".constantize
    end

    def call
      client = OpenAI::Client.new(request_timeout: 340)
      response = client.chat(
        parameters: {
            # model: "gpt-4-1106-preview",
             model: "gpt-3.5-turbo-1106",
            response_format: { "type": "json_object" },
            messages: [
              {
                role: "system",
                content: "You are a helpful assistant designed to output JSON"
              },
              { role: "user", content: prompt}],
            max_tokens: 4096,
            temperature: 1.3,
            top_p: 0.5
      })
      
      fail!(errors: response["error"]["message"]) if response["error"].present?

      content = JSON.parse(response['choices'][0]["message"]["content"])
      fail!(errors: content["error"]) if content["error"].present?
      context.response = response
      context.content = content
      update_statistics!(response["usage"]["total_tokens"])
    end

    private

    def update_statistics!(words_used)
      Statistics.where(integration_id: integration.id).update_all("#{field} = #{field} + #{count} , total_words = total_words + #{words_used}")
      subscription = integration&.subscription
      remaining_generations =  subscription.remaining_generations - self.class.calculate_tokens(params).to_i
      subscription.update_attribute(:remaining_generations, remaining_generations)
    end

    def field
    end

    def count
      1
    end

    def prompt
      ""
    end
  end
end