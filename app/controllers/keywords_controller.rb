class KeywordsController < ApplicationController
  before_action :set_integration

  def index
    keywords = @integration.keywords
    keywords = keywords.search_by_name(params[:name]) if params[:name].present?
    keywords = keywords.page(params[:page] || 1).per(params[:per_page] || 10)
    meta = { total_pages: keywords.total_pages, total_count: keywords.total_count, current_page: keywords.current_page, per_page: keywords.limit_value }
    render json: { keywords: keywords, meta: meta }, status: :ok
  end

  def upsert
    keywords = keyword_params[:keywords].map { |keyword| keyword.to_h.merge(integration_id: @integration.id)}.uniq
    if Keyword.upsert_all(keywords, unique_by: [:integration_id, :name])
      render json: { message: "Keyword successfully upserted" }, status: :ok
    else
      render json: { errors: "Failed to upsert keyword" }, status: :unprocessable_entity
    end
  end

  def destroy
    keyword = @integration.keywords.find(params[:id])
    if keyword.destroy
    render json: { message: "Keyword successfully deleted" }, status: :ok
    else
      render json: { errors: "Failed to delete keyword" }, status: :unprocessable_entity
    end
  end

  private 

  def keyword_params
    params.permit(keywords: [:name, :monthly_searches, :competition, monthly_search_volumes: [:year, :month, :monthly_searches]])
  end

  def set_integration
    @integration = Integration.find(params[:integration_id])
  end
end
