module Videos
  class TranscribeAudio
    include Interactor

    delegate :video_info, to: :context

    def call
      audio_file = video_info['_filename']
      context.transcription_text = transcribe_audio(audio_file)
      File.delete(audio_file)
    rescue StandardError => e
      context.fail!(error: e.message)
    end

    private
    def transcribe_audio(file_path)
      client = OpenAI::Client.new
      response = client.audio.transcribe(
      parameters: {
        model: "whisper-1",
        file: File.open(file_path, "rb"),})
      response['text']
    end
  end
end
