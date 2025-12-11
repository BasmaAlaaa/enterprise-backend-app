class Openai::GenerateBatchJob
  include Sidekiq::Job

  def perform(params, generation_id)
    generation = Generation.find_by(id: generation_id)
    return if generation.blank?
    result =  OpenAi::Batch::Organizers::GenerateBatch.call(params: params.with_indifferent_access, integration: generation.integration, generation: generation, entity: generation)
    if result.failure?
      generation.errors_message = result.errors
      generation.failed!
      return {success: false, errors: result.errors}
    else
      return {success: true}
    end
  end
end