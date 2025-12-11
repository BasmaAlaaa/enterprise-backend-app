module OpenAi::Batch
  class GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    def call
      context.prompts = params[:batch_data].map do |attribute|
        {
          custom_id: custom_id(attribute),
          method: "POST",
          url: "/v1/chat/completions",
          body: {
            model: model,
            messages: [
              { role: "system", content: "You are a helpful assistant." },
              { role: "user", content: prompt_content(attribute) }
            ]
          }
        }.to_json
      end
      context.field = field
      context.tokens = calculate_tokens(params)
    end

    def calculate_tokens(params)
      params[:batch_data].size * generation_used
    end

    private

    def generation_used
      1
    end

    def prompt_content(attribute)
      ""
    end

    def custom_id(attribute)
      ""
    end

    def field
      ""
    end

    def model
      "gpt-4o"
    end
  end
end
