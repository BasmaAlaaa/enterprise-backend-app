class SearchConsoleController < GoogleAuthController
  before_action :set_integration
  before_action :authenticate_user!, only: [:index, :performance, :keyword_performance, :url_index]

  def google_oauth2
    state = { integration: @integration}
    handler = Integrations::Google::GoogleAuthHandler.new(@integration)
    render json: { authorization_uri: handler.authorization_uri(state) }
  end

  def index
    result = SearchConsole::Index.call(integration: @integration)
    if result.success?
      render json: result.sites
    else
      render json: { error: result.error }, status: result.status
    end
  end

  def performance
    result = SearchConsole::Performance.call(integration: @integration, params: params)
     render_response(result)
  end

  def performance_graph
    result = SearchConsole::PerformanceGraph.call(integration: @integration, params: params)
      render_response(result)
  end

  def keyword_performance
    result = SearchConsole::KeywordPerformance.call(integration: @integration, params: params)
     render_response(result)
  end

  def signout
    handler = Integrations::Google::GoogleAuthHandler.new(@integration)
    handler.signout
    redirect_to ENV['FRONTEND_REDIRECT_URI'], allow_other_host: true
  end

  private

  def render_response(result)
    handler = Integrations::Google::GoogleAuthHandler.new(@integration)
    response = handler.handle_response(result)
    render response
  end

  def set_integration
    @integration = Integration.find(params[:integration_id])
  end
end
