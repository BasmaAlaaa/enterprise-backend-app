module OpenAi
  class GenerateAltText < OpenAi::Generate
    include Interactor
    delegate :vision_data, :integration, :fail!, to: :context

    GENERATION_USED = 2

    def self.calculate_tokens(params)
      return 2 unless params[:alt_text_type].present?

      return params[:old_content][:attributes].flatten.count * 2 if params[:alt_text_type] == "single"

      count = 0

      params[:old_content][:attributes].each { |record| count+= record[:images].count }
      2 * count
    end

    private

    def call
      client = OpenAI::Client.new(request_timeout: 340)
      response = client.chat(
        parameters: {
            model: "gpt-4-vision-preview",
            messages: [{ role: "user", content: prompt}],
            max_tokens: 4096,
        }
      )

      fail!(errors: response["error"]["message"]) if response["error"].present?
      context.response = response
      context.content = {alt_text: response['choices'][0]["message"]["content"]}
      update_statistics!(response["usage"]["total_tokens"])


    end

    def prompt
     vision_data || [
        { type: "text", "text": "Generate concise and descriptive SEO-friendly alt-text for this image, focus on its key elements, keep it within 150 characters limit and incorporate relevant keywords for SEO."},
        { type: "image_url",
          image_url: {
            url: params[:image_url]
            # "url": "https://cdn.shopify.com/s/files/1/0695/4165/8919/articles/img-Ned3jYLR61saxWUtru9ZVVxa.png?v=1705774719",
          },
        }
      ]
    end

    def field
      "image_alt_text"
    end
  end
end