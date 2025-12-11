module Videos
  class DownloadAudio
    include Interactor

    delegate :url, to: :context
    def call
      output_path = 'public/downloads/audio.m4a'
      duration = 1800
      command = <<-CMD
      yt-dlp -f 'bestaudio[ext=m4a]/bestaudio' --extract-audio --audio-format m4a \
      --output '#{output_path}' --no-color --no-progress --print-json \
      --postprocessor-args "FFmpeg:-t #{duration}" #{url}
       CMD
      output =`#{command}`
      raise "yt-dlp failed: #{output}" unless $?.success?
      context.video_info = { '_filename' => output_path }
    rescue StandardError => e
      context.fail!(error: e.message)
    end
  end
end
