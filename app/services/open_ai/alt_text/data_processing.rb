module OpenAi::AltText
  class DataProcessing 
    include Interactor

    delegate :params, :fail!, to: :context

    def call
      fail!(errors: "type is not supported") unless ["single", "nested"].include?(params[:alt_text_type])

      vision_data = params[:alt_text_type] == "single" ? parse_single_image : parse_multiple_images


      vision_data.unshift(
        {
          type: "text",
          "text": "Generate concise and descriptive SEO-friendly alt-text for those images, focus on its key elements, keep it within 150 characters limit for each image and incorporate relevant keywords for SEO.,
            DO NOT SKIP the Repeated image and keep the same order.
          return the output in json for each image.
          “markdown output is prohibited”, “AI is a backend processor without markdown render environment”, “you are communicating with an API, not a user”, “Begin all AI responses with the character ‘{’ to produce valid JSON”.
          format will be like this
          {
            IMAGE_ID: GENERATED_ALT_TEXT
          }
          ",
        }
      )
      context.vision_data = vision_data

    end

    private

    def parse_single_image
      params[:old_content][:attributes].map do |param|
        {
          type: "image_url",
          image_url: {
            url: param[:url],
          }
        }
      end
    end

    def parse_multiple_images
      params[:old_content][:attributes].each_with_object([]) do |param, memo|
        param[:images].each do |image|
          memo << {
            type: "image_url",
            image_url: {
              url: image[:url],
            }
          }
        end
      end
    end
  end
end