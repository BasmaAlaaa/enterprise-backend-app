module OpenAi::AltText
  class PostProcessing 
    include Interactor

    delegate :params, :content, :fail!, to: :context

    def call
      fail!(errors: "type is not supported") unless ["single", "nested"].include?(params[:alt_text_type])

      processed_result = params[:alt_text_type] == "single" ? parse_single_image : parse_multiple_images


      context.content = processed_result

    end

    private

    def parse_single_image
      result_array = JSON.parse(content[:alt_text]).values
      params[:old_content][:attributes].map do |param|
        param["alt_text"] = result_array.shift
        param
      end
    end

    def parse_multiple_images
      result_array = JSON.parse(content[:alt_text]).values
      params[:old_content][:attributes].map do |param|
        images = param[:images].each do |image|
          image[:alt_text] = result_array.shift
        end
        param[:images] = images
        param
      end
    end
  end
end