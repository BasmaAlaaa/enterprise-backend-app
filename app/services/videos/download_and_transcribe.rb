module Videos
  class DownloadAndTranscribe
    include Interactor::Organizer
    organize DownloadAudio, TranscribeAudio
  end
end
