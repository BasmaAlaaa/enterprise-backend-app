class Openai::GenerateJob
  include Sidekiq::Job

  def perform(params, classes, generation_id)
    generation = Generation.find_by(id: generation_id)
    return if generation.blank?
    results = Hash.new { |h, k| h[k] = {} }
    classes.each do |klass|
      klass = "OpenAi::#{klass}".constantize
      result =  klass.call(params: params.with_indifferent_access, integration: generation.integration, generation: generation)
      content = generation.content || {}
      if result.success?
        process_success_result(result, results, params)
      else
        generation.update(errors_message: result.error)
        generation.failed!
        return
      end
    end
    generation.update(content: results)
    generation.done!

  rescue StandardError, LoadError => e
    generation.errors_message = e.message
    generation.failed!
  end

  def process_success_result(result, results, params)
    results.merge!(result.content)
  end
end
