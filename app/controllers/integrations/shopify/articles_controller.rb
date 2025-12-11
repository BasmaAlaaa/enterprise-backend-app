class Integrations::Shopify::ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
   result = Integrations::Shopify::FetchArticles.call(
      user: current_user,
      params: params
    )
    if result.success?
      render(json: { articles: result.articles, pagination: result.pagination })
    else
      render(json: { errors: result.errors }, status: :not_found)
    end
  end

  def show
    result = Integrations::Shopify::FetchArticle.call(user: current_user, params: params)

    if result.success?
      render(json: { article: result.article })
    else
      render(json: { errors: result.error }, status: :unprocessable_entity)
    end
  end


  def create
    result = Integrations::Shopify::CreateArticle.call(
      user: current_user,
      params: params,
      article_params: article_params
    )

    if result.success?
      render json: { article: result.article }, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def update
    result = Integrations::Shopify::UpdateArticle.call(
      user: current_user,
      params: params,
      article_params: article_params
    )

    if result.success?
      render json: {}, status: :ok
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def bulk_update
    result = Integrations::Shopify::BulkUpdateArticles.call(
      user: current_user,
      params: params,
      bulk_article_params: bulk_article_params
    )

    if result.failed_articles.empty?
      render json: {}, status: :ok
    else
      render json: { failed_articles: result.failed_articles }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(
      :blog_id,
      :description,
      :author,
      :tags,
      :body_html,
      :title,
      :handle,
      :summary_html,
      :published,
      :published_at,
      :published_date,
      image: {},
      metafields: [:namespace, :value, :type, :key, :id])
  end

  def bulk_article_params
    params.require(:articles).permit(attributes: [:id, :blog_id, image: {}])
  end
end
