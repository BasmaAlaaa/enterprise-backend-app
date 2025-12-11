module SearchConsole
  class Performance
    include Interactor

    delegate :integration, :params, :fail!, to: :context

    def call
      service = Integrations::Google::GoogleAuthHandler.new(integration)
      filters = []
      if params[:uri]
        filters << {
          dimension: 'page',
          operator: 'contains',
          expression: params[:uri]
        }
      end
      if params[:country]
        filters << {
          dimension: 'country',
          operator: 'contains',
          expression: params[:country]
        }
      end
      if params[:device]
        filters << {
          dimension: 'device',
          operator: 'contains',
          expression: params[:device]
        }
      end
      if params[:query]
        filters << {
          dimension: 'query',
          operator: 'contains',
          expression: params[:query]
        }
      end
      request = Google::Apis::WebmastersV3::SearchAnalyticsQueryRequest.new(
        start_date: params[:start_date] || 30.days.ago.to_date.to_s,
        end_date: params[:end_date] || Date.today.to_s,
        dimensions:params[:dimensions] || ['query', 'page', 'country', 'device'],
        dimension_filter_groups: [{
          group_type: 'and',
          filters: filters
        }],
        aggregation_type: 'auto',
        row_limit: params[:row_limit] || 1000,
        start_row: params[:start_row] || 0
      )
      response = service.query_search_analytics(params[:url], request)
      if response.is_a?(Hash) && response[:error]
        fail!(error: response[:error], status: response[:status])
      else
        rows = response.rows || []
        context.response = paginate_response(rows)
      end
    end

    private

    def paginate_response(rows)
      per_page = (params[:per_page] || 10).to_i
      current_page = (params[:page] || 1).to_i
      total_count = rows.size
      paginated_rows = Kaminari.paginate_array(rows).page(current_page).per(per_page)
      {
        meta: {
          per_page: per_page,
          current_page: current_page,
          total_pages: paginated_rows.total_pages,
          total_count: total_count
        },
        data: paginated_rows
      }
    end
  end
end
