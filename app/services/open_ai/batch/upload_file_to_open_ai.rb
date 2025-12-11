module OpenAi
  module Batch
    class UploadFileToOpenAi
      include Interactor

      delegate :prompts, :fail!, to: :context

      def call
        Tempfile.create(['jsonl_file', '.jsonl']) do |file|
          file.puts(prompts) 
          file.flush
          upload_file_to_openai(file.path)
        end
      rescue => e
        fail!(error: "Error processing request: #{e.message}")
      end

      private

      def upload_file_to_openai(file_path)
        client = OpenAI::Client.new
        response = client.files.upload(
          parameters: {
            file: File.open(file_path, 'rb'),
            purpose: 'batch'
          }
        )
        context.file_id = response['id']
        if response['status'] == 'failed'
          fail!(error: response['error'])
        end
      end
    end
  end
end
