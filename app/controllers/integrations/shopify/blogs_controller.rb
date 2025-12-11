class Integrations::Shopify::BlogsController < ApplicationController
  before_action :authenticate_user!

  def index
    result = Integrations::Shopify::FetchBlogs.call(
      user: current_user,
      params: params
    )

    if result.success?
      render(json: { articles: result.articles, has_next_page: result.has_next_page })
    else
      render(json: { errors: result.errors }, status: :not_found)
    end
  end
end
