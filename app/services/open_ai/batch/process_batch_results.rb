module OpenAi
  module Batch
    class ProcessBatchResults
      include Interactor

      delegate :output_response, :generation, :fail!, to: :context

      def call
        return unless context.output_response.present?
        results = Hash.new { |h, k| h[k] = {} }
        output_response.each do |line|
          custom_id = line["custom_id"]
          id = custom_id.split('-').last.to_i
          type = custom_id.split('-').first
          response_content = line.dig("response", "body", "choices", 0, "message", "content")
          content = (type == "title" || type == "seo_title") ? sanitize_title(response_content) : sanitize_content(response_content);
          if type == "description" && generation.generation_type == "products"
            results[id][type] = [content]
          else
            results[id][type] = content
          end
        end
        formatted_results = format_results(results)
        if generation.update(content: formatted_results)
          generation.done!
        end
      rescue => e
        fail!(error: "An error occurred while processing batch results: #{e.message}")
      end

      private

      def format_results(results_hash)
        results_hash.map do |id, types|
          { id: id }.merge(types)
        end
      end

      def sanitize_content(content)
        return "" if content.nil?
        content.gsub(/```html/, '').gsub(/```/, '').strip
      end

      def sanitize_title(title)
        title.gsub(/["'\\\/]/, '').strip
      end      
    end
  end
end