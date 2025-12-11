module OpenAi::BlogPosts
  class GenerateVideoTitle < OpenAi::Generate
    include Interactor
    GENERATION_USED = 3

    private
    def prompt
      "You are an expert in digital content creation. Generate a title for the video from this transcription #{transcribe}. 
      Ensure the title includes high search volume keywords within the first 50 characters and is no more than 70 characters in length."
    end

      def transcribe
        cache_key = "video_transcription:#{params[:url]}"
        Rails.cache.fetch(cache_key, expires_in: 12.hours) do
          result = Videos::DownloadAndTranscribe.call(url: params[:url])
          return { error: "Transcription failed" } if result.transcription_text.nil?
          result.transcription_text
        end
      end

    def field
      "article_title"
    end
  end
end
