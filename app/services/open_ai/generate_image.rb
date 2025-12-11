module OpenAi
  class GenerateImage
    include Interactor

    delegate :params, :integration, :fail!, to: :context
    def call
      # params = {
      #   size: "512x512", # or 256x256 or 1024x1024    
      #   format: "photograph",                         
      #   subject: "whale in space",                    
      #   perspective: "through a porthole",            
      #   vibe: "futuristic",                           
      #   booster: "4k resolution",  
      #   exclusion: "no planets",
      #   style: "surrealism",                          
      #   klass: "GenerateImage"
      # }
      client = OpenAI::Client.new
      response = client.images.generate(parameters: {
        prompt: "#{params[:format]} of a #{params[:subject]},
        #{params[:perspective]}, in the style of #{params[:style]}, #{params[:vibe]} ,#{params[:booster]}, Exclude (#{params[:exclusion]})", 
        size: params[:size],
        model: "dall-e-3"
      })

      fail!(errors: response["error"]["message"]) if response["error"].present?
      
      update_statistics!
      context.content = {url: response.dig("data", 0, "url")}
    end

    private

    def update_statistics!
      Statistics.where(integration_id:integration.id).update_all("images = images + 1")
      subscription = integration&.subscription
      remaining_images =  subscription.remaining_images - 1
      subscription.update_attribute(:remaining_images, remaining_images)
    end
  end
end