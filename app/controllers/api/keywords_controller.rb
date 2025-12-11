# frozen_string_literal: true

class Api::KeywordsController < Api::BaseController
  # before_action :authorize_subscription!, except: [:index]
  before_action :validate_create_params!, only: :create
  before_action :set_integration

  def create
    generations = @integration.generations.where(status: [:processing, :streaming])
    return render json: {errors: "There is a generation already processing"}, status: :unprocessable_entity if generations.present?

    generation = Generation.keyword_ideas.new(
      integration_id: @integration.id, status: :processing,
    )
    return render json: {errors: generation.errors}, status: :unprocessable_entity unless generation.save

    GoogleAds::GenerateJob.perform_async(
      permitted_params.to_h,
      generation.id
    )
    render json: {message: "This kind of generation can take some minutes, you can fetch it when it's done", generation_id: generation.id}
  end
  
  private

  def validate_create_params!
    required_fields = [:location_ids, :language_id, :keywords]

    missing_fields = required_fields.select { |field| permitted_params[field].blank? }

    if missing_fields.any?
      return render json: {errors: "Missing required fields: #{missing_fields.join(', ')}"}, status: :unprocessable_entity
    end

  end

  def set_integration
    @integration = current_user.integrations.find_by(id: params[:integration_id])
  end
  
  def permitted_params
    params.permit(:language_id, :page_url, :include_adult_keywords, location_ids: [], keywords: [])
  end
end
