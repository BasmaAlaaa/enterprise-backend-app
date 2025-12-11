class Api::GenerationsController < Api::BaseController
  before_action :set_integration , only: [:index, :show]

  def index
    generations = @integration.generations.order(created_at: :desc)

    generations = generations.where(status: params[:status]) if params[:status]
    generations = generations.by_type(params[:generation_type]) if params[:generation_type]
    generations = generations.by_project(params[:project_id]) if params[:project_id]

    generations = generations.page(params[:page] || 1).per(params[:per_page] || 10)

    meta = {
      total_pages: generations.total_pages,
      total_count: generations.total_count,
      current_page: generations.current_page,
      per_page: generations.limit_value
    }
    render json: {generations: generations.select(:id, :generation_type, :created_at, :status),  meta: meta}
  end

  def show
    generation = @integration.generations.find(params[:id])
    if generation.batch_id.present? && generation.processing?
      result = OpenAi::Batch::Organizers::RetrieveBatch.call(generation: generation, entity: generation)
      return render json: generation unless result.status == "completed"
      return render json: {errors: result.error}, status: :unprocessable_entity if result.error.present?
      display_content(generation)
    else
      display_content(generation)
    end
  end

  def update
    generation = Generation.find(params[:id])
    generation.update(project_id: params[:project_id])
    render json: {message: "Generation #{generation.id} assigned to project #{params[:project_id]}"}
  end

  private
  
  def set_integration
    @integration = Integration.find(params[:integration_id])
  end

  def pagination_meta(collection)
    {
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      current_page: collection.current_page,
      per_page: collection.limit_value
    }
  end

  def paginate_content(generation)
    content = generation.content.presence || []
    content_array = content.is_a?(Hash) ? [content] : content
    Kaminari.paginate_array(content_array).page(params[:content_page] || 1).per(params[:content_per_page] || 10)
  end

  def display_content(generation)
    paginated_content = paginate_content(generation)
    generation.content = paginated_content
    render(json: { generation: generation, meta: pagination_meta(paginated_content)})
  end
end