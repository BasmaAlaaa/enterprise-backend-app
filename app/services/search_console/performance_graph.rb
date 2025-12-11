module SearchConsole
  class PerformanceGraph
    include Interactor

    delegate :integration, :params, :fail!, to: :context

    def call
      service = Integrations::Google::GoogleAuthHandler.new(integration)
      selected_range_metrics = fetch_metrics(service, params[:start_date], params[:end_date])
      previous_start_date, previous_end_date = calculate_previous_date_range(params[:start_date], params[:end_date])
      previous_range_metrics = fetch_metrics(service, previous_start_date, previous_end_date)
      if selected_range_metrics[:error] || previous_range_metrics[:error]
        fail!(error: selected_range_metrics[:error] || previous_range_metrics[:error], status: selected_range_metrics[:status] || previous_range_metrics[:status])
      else
        rate_of_change = calculate_rate_of_change(selected_range_metrics, previous_range_metrics)
        context.response = formulate_response(selected_range_metrics[:rows], rate_of_change)
      end
    end

    private

    def build_request(start_date, end_date)
      Google::Apis::WebmastersV3::SearchAnalyticsQueryRequest.new(
        start_date: start_date || 29.days.ago.to_date.to_s,
        end_date: end_date || Date.today.to_s,
        dimensions: ['date'],
        aggregation_type: 'auto'
      )
    end

    def fetch_metrics(service, start_date, end_date)
      request = build_request(start_date, end_date)
      response = service.query_search_analytics(params[:url], request)
      if response.is_a?(Hash) && response[:error]
        { error: response[:error], status: response[:status] }
      else
        rows = response.rows || []
        {
          rows: rows,
          total_clicks: rows.sum { |row| row.clicks.to_i },
          total_impressions: rows.sum { |row| row.impressions.to_i },
          total_ctr: rows.sum { |row| row.ctr.to_f },
          total_position: rows.sum { |row| row.position.to_f }
        }
      end
    end

    def calculate_previous_date_range(start_date, end_date)
      start_date = start_date.present? ? Date.parse(start_date) : 29.days.ago.to_date
      end_date = end_date.present? ? Date.parse(end_date) : Date.today
      period = end_date - start_date
      previous_end_date = start_date - 1.day
      previous_start_date = previous_end_date - period
      [previous_start_date.to_s, previous_end_date.to_s]
    end

    def calculate_rate_of_change(current, previous)
      {
        clicks_rate_of_change: calculate_formula(current[:total_clicks], previous[:total_clicks]),
        impressions_rate_of_change: calculate_formula(current[:total_impressions], previous[:total_impressions]),
        ctr_rate_of_change: calculate_formula(current[:total_ctr], previous[:total_ctr]),
        position_rate_of_change: calculate_formula(current[:total_position], previous[:total_position])
      }
    end

    def calculate_formula(current, previous)
      return 0 if previous.zero?
      100 - ((current.to_f / previous) * 100)
    end

    def formulate_response(rows, rate_of_change)
      rows_size = rows.empty? ? 1 : rows.size
      {
        meta: {
          total_clicks: rows.sum { |row| row.clicks.to_i },
          total_impressions: rows.sum { |row| row.impressions.to_i },
          average_ctr: (rows.sum { |row| row.ctr.to_f } / rows_size) * 100,
          average_position: rows.sum { |row| row.position.to_f } / rows_size,
          clicks_rate_of_change: rate_of_change[:clicks_rate_of_change],
          impressions_rate_of_change: rate_of_change[:impressions_rate_of_change],
          ctr_rate_of_change: rate_of_change[:ctr_rate_of_change],
          position_rate_of_change: rate_of_change[:position_rate_of_change]
        },
        data: rows
      }
    end
  end
end
