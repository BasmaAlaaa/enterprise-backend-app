# frozen_string_literal: true

class Api::OpenAiController < AuthController
  # before_action :authorize_subscription!, except: [:index]
  before_action :set_integration
  before_action :validate_tokens, only: [:create, :generate_background]

  def create
    klass = "OpenAi::#{params[:klass]}".constantize
    result =  klass.call(params: ai_params.to_h, integration: @integration)

    if result.success?
       render json: result.content
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def index
    generation = @integration.generations.where(generation_type: params[:generation_type]).last

    render json: generation
  end

  def reset_generation
    generation = @integration.generations.where(generation_type: params[:generation_type]).last
    return render json: {errors: "There is a generation already processing"}, status: :unprocessable_entity if generation.processing?

    generation.hidden!
  end

  def generate_background
    return render json: {errors: "There are already two generations processing"}, status: :unprocessable_entity if @integration.generations.processing.count >= 2

    generation = Generation.new(
      integration_id: @integration.id, status: :processing,
      generation_type: params[:generation_type],
      old_content: ai_params[:old_content])
    return render json: {errors: generation.errors}, status: :unprocessable_entity unless generation.save

    Openai::GenerateJob.perform_async(
      ai_params.to_unsafe_h.deep_transform_keys { |key| key.to_s },
      ai_params[:classes],
      generation.id
    )
    render json: {message: "This kind of generation can take some minutes, you can fetch it when it's done"  , generation_id: generation.id}
  end

  def generate_batch_articles
    batch_group = BatchGroup.new(name: params[:batch_name], status: :processing, generation_type: params[:generation_type], integration_id: @integration.id)     
    return render json: {errors: batch_group.errors}, status: :unprocessable_entity unless batch_group.save

    result = Openai::GenerateBatchArticlesJob.new.perform(
      ai_params.to_unsafe_h.deep_transform_keys { |key| key.to_s },
      @integration.id,
      batch_group.id
    )
    if result[:success]
      render json: {message: "This kind of generation can take some minutes, you can fetch it when it's done", batch_group_id: batch_group.id}
    else
      render json: {errors: result[:errors]}, status: :unprocessable_entity
    end
  end

  def generate_batch
    generation = Generation.new(integration_id: @integration.id, status: :processing, generation_type: params[:generation_type], old_content: ai_params[:batch_data])
    return render json: {errors: generation.errors}, status: :unprocessable_entity unless generation.save

    result = Openai::GenerateBatchJob.new.perform(
      ai_params.to_unsafe_h.deep_transform_keys { |key| key.to_s },
      generation.id,
    )
    if result[:success]
      render json: {message: "This kind of generation can take some minutes, you can fetch it when it's done", generation_id: generation.id}
    else
      render json: {errors: result[:errors]}, status: :unprocessable_entity
    end
  end

  def destroy
    generation = @integration.generations.find(params[:id])
    if generation.destroy
      render json: {}
    else
      render json: {errors: generation.errors}, status: :unprocessable_entity
    end
  end


  private
  def validate_tokens
    params[:classes] ||= [params[:klass]]
    result = OpenAi::ValidateTokens.call(integration: @integration, params: params)
    return render json: {errors: result.errors}, status: :unprocessable_entity if result.errors.present?
  end

  def ai_params
    params.permit(:title, :products, :description, :store, :language, :content, :include_keywords, :avoid_keywords, :tone, :text_length,
    :material, :style, :length, :topic, :bullet_points, :excerpt, :cta, :user_prompt, :image_url, :batch_name, :url, :main_theme,
    :creativity_level, :results_count, :number_of_collections, :number_of_products, :article_type,:generation_type, :integration_id,
    :size, :format, :subject, :perspective, :vibe, :exclusion, :booster, :target_audience, :content, :alt_text_type,
    collections: [:id, :title],
    extra_links: [],
    classes: [],
    topics:[],
    modifiers: [],
    internal_links: [:title, :url],
    old_content: {},
    batch_data: [:topic, :title, :product_description, :content, :excerpt, :id]
  )
  end
  def set_integration
    @integration = Integration.find(params[:integration_id])
  end
end
