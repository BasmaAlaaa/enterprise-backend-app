module OpenAi
  module BatchArticles
    class ProcessBatchResults
      include Interactor

      delegate :output_response, :integration, :batch_group, :fail!, to: :context

      def call
        return unless context.output_response.present?
        results = Hash.new { |h, k| h[k] = {} }
        output_response.each do |line|
          custom_id = line["custom_id"]
          title = custom_id.split('-').last
          type = custom_id.split('-').first
          response_content = line.dig("response", "body", "choices", 0, "message", "content")
          content = type.include?("title") ? sanitize_title(response_content) : sanitize_content(response_content)
          results[title][type] = content
        end
        generations = []
        results.each do |title, types|
          generation = Generation.new(batch_group_id: batch_group.id, integration_id: integration.id, status: :done, generation_type: :article, content: format_results(title, types), created_at: Time.current, updated_at: Time.current)
          generations << generation.attributes.except("id")
        end
        Generation.insert_all(generations)
        batch_group.update!(status: :done, batch_status: context.status, batch_request_counts: context.request_counts)
      rescue => e
        fail!(error: "An error occurred while processing batch results: #{e.message}")
      end

      private

      def format_results(title, types)
        { title: title }.merge(types)
      end

      def sanitize_content(content)
        return "" if content.nil?
        content.gsub(/```html/, '').gsub(/```/, '').strip
      end

      def sanitize_title(title)
        title.gsub(/["'\\#\/]/, '').strip
      end
    end
  end
end