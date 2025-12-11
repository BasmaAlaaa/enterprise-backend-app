class GoogleAds::GenerateJob
  include Sidekiq::Job

  def perform(params, generation_id)
    generation = Generation.find_by(id: generation_id)
    return if generation.blank?

    GoogleAds::Organizers::GenerateKeywords.call(
      **params, generation_id: generation_id
    )
  rescue StandardError, LoadError => e
    generation.errors_message = e.message
    generation.failed!
  end
end

