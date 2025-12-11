module PaginationHelper
  def paginate(collection)
    collection = collection.page(params[:page] || 1).per(params[:per_page] || 10)
    meta =  {
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      current_page: collection.current_page,
      per_page: collection.limit_value
    }
    render json: collection,  meta: meta
  end
end