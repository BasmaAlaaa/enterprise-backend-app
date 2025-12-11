module OpenAi::Batch::AltText
  class GenerateAltTextPrompts < OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private

    def prompt_content(attribute)
      [
        { type: "text", "text": "Generate concise and descriptive SEO-friendly alt-text for this image, focus on its key elements, keep it within 150 characters limit and incorporate relevant keywords for SEO."},
        { type: "image_url",
          image_url: {
            url: attribute[:image_url]
          },
        }
      ]
    end

    def custom_id(attribute)
      "alt_text-#{attribute[:id]}"
    end

    def field
      "image_alt_text"
    end

    def generation_used
      2
    end

    def model
      "gpt-4o"
    end
  end
end
