module WordPressPaginationHelper
  def self.pagination(pagination_data)
    current_page = pagination_data["current_page"].to_i
    total_pages = pagination_data["total_pages"].to_i
    {
      hasNextPage: pagination_data["has_next_page"],
      hasPreviousPage: pagination_data["has_previous_page"],
      next: current_page < total_pages ? current_page + 1 : nil,
      current: current_page,
      totalPages: total_pages
    }
  end
end