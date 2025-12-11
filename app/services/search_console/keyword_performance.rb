module SearchConsole
  class KeywordPerformance
    include Interactor

    delegate :integration, :params, :fail!, to: :context

    def call
      service = Integrations::Google::GoogleAuthHandler.new(integration)
      request = Google::Apis::WebmastersV3::SearchAnalyticsQueryRequest.new(
        start_date:  params[:start_date] || 30.days.ago.to_date.to_s,
        end_date: params[:end_date] || Date.today.to_s,
        dimensions: ['query'],
        dimension_filter_groups: [{
          filters: [{
            dimension: 'query',
            expression: params[:keyword]
          }]
        }]
      )
      response = service.query_search_analytics(params[:url], request)
      if response.is_a?(Hash) && response[:error]
        fail!(error: response[:error], status: response[:status])
      else
        context.response = response
      end
    end
  end
end
