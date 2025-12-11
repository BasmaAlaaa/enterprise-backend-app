class Openai::GenerateBatchArticlesJob
  include Sidekiq::Job

  def perform(params, integration_id, batch_group_id)
    batch_group = BatchGroup.find_by(id: batch_group_id)
    integration = Integration.find_by(id: integration_id)
    return if batch_group.blank?
    result =  OpenAi::BatchArticles::Organizers::GenerateBatch.call(params: params.with_indifferent_access, integration: integration, batch_group: batch_group, entity: batch_group)
    if result.failure?
      batch_group.errors_message = result.error
      batch_group.failed!
      return {success: false, errors: result.error}
    else
      return {success: true}
    end
  end
end
