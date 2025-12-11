class Api::BatchGroupsController < AuthController
  before_action :set_batch_group, only: [:show]

  def show
    if @batch_group.batch_id.present? && @batch_group.processing?
      result = OpenAi::BatchArticles::Organizers::RetrieveBatch.call(entity: @batch_group, batch_group: @batch_group, integration: @batch_group.integration)
      return render json: {errors: result.error}, status: :unprocessable_entity if result.error.present?
      render(json: {batch_group: @batch_group, batch_group_generations: @batch_group.generations})
    else
      render(json: {batch_group: @batch_group , batch_group_generations: @batch_group.generations })
    end
  end

  private 

  def set_batch_group
    @batch_group = BatchGroup.find(params[:id])
  end
end