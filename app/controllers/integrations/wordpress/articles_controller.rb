class Integrations::Wordpress::ArticlesController< ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::WordPress::FetchPosts.call(user: current_user, wordpress_id: params[:wordpress_id], per_page: params[:per_page], page: params[:page], search: params[:search])
    if result.success?
      render(json: { posts: result.posts , pagination: WordPressPaginationHelper::pagination(result.pagination)})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def show 
    result = Integrations::WordPress::ShowPost.call(user: current_user, wordpress_id: params[:wordpress_id], id: params[:id])
    if result.success?
      render(json: { response: result.post})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def create
    result = Integrations::WordPress::CreatePost.call(user: current_user, wordpress_id: params[:wordpress_id], params: post_params)
    if result.success?
      render(json: { response: result.post})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def update
    result = Integrations::WordPress::UpdatePost.call(user: current_user, wordpress_id: params[:wordpress_id], params: post_params)
    if result.success?
      render(json: { response: result.post})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  private 

  def post_params
    params.permit(:id, :wordpress_id, :title, :content, :per_page, :page, :search, :excerpt, :description, :url, :alt, seo: [:seo_title, :seo_description, :seo_url])
  end
end
