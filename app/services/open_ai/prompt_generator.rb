module OpenAi
  class PromptGenerator
    include Interactor

    delegate :max_tokens, :params, to: :context

    def call

    
    end

    private

    #title = "mohamed"
    #store_name = "pixel"
    #language = "English"
    #size = "S,M,L"
    #colors = 'Green,Black,Yellow'
    #style = 'casual'
    #materials = "cotton,wood"
    #include_keywords= "summer,hot"
    #avoid_keywords= "summer,hot"
    #tone="funny"
    #text_length=50
    #results_count = 1
    #creativity_level = high
    #bullet_points='Include'
    #bold_text='Include'
    #cta = 'Do not Include'




    def body(params)
        "Enhance this product title [#{params[:title]}]
        -Set Output Title & Description Language to  [#{params[:language]}]
        -Include #{params[:store_name]} in the description 
        Generate a compelling description using the following inputs: 
       \n\n1-Attributes:\n- Variants:
        #{attributes}
        \n\n2-Keywords:\n
        -Keywords to Include:* [#{params[:include_keywords]}]\n
        -Keywords to Avoid:* [#{params[:avoid_keywords]}]\n\n
        \n\n3-Details:\n
        -Tone: (#{params[:tone]})\n
        -Text Length: (#{params[:text_length]} words) \n
        -Number of Options to Generate: (#{params[:results_count]}) \n
        -Creativity Level: (#{params[:creativity_level]})\n\n
        \n\n4-Description Formatting:*\n
        -Bullet Points: #{params[:bullet_points]}\n
        -Bold Text: #{params[:bold_text]}\n
        -Call to Action (CTA): #{params[:cta]}"
    end
  end

  def attributes
    result = ""
    result << "-Sizes (#{params[:sizes]})\n-" if params[:sizes].present?
    result << "-Colors: (#{params[:colors]})\n" if params[:colors].present?
    result << "-Materials: (#{params[:materials]})\n" if params[:materials].present?
    result << "-Style: #{params[:style]} \n\n" if params[:style].present?
  end
end