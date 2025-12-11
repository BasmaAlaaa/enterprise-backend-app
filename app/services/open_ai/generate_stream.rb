module OpenAi
  class GenerateStream
    include Interactor

    delegate :max_tokens,:integration, :params, :use_stream, :generation, :fail!, to: :context
    GENERATION_USED = 1
    def self.calculate_tokens(params)
      "#{self}::GENERATION_USED".constantize
    end

    def call
      client = OpenAI::Client.new(request_timeout: 340)
      context.streamed_result = ""
      client.chat(
        parameters: {
            model: "gpt-4-1106-preview",
            # model: "gpt-3.5-turbo-1106",
            # response_format: { "type": "json_object" },
            messages: [
              {
                role: "system",
                content: "You are a helpful assistant designed to output streamed content"
              },
              { role: "user", content: prompt}],
            max_tokens: 4096,
            temperature: 1.3,
            top_p: 0.5,
            stream: stream
      })

      context.content = {"#{json_key}": context.streamed_result}
      used_tokens = OpenAI.rough_token_count(context.streamed_result) + OpenAI.rough_token_count(send(:prompt))
      update_statistics!(used_tokens)
    end

    private

    def stream
      proc do |chunk, _bytesize|
        generation.streaming! unless generation.streaming?
        data = chunk.dig("choices", 0, "delta", "content")
        context.streamed_result += data if data.is_a?(String)
        ActionCable.server.broadcast(
          stream_channel,
          {content: context.streamed_result, finished: chunk["choices"][0]["finish_reason"].present?}
        )
      end
    end

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