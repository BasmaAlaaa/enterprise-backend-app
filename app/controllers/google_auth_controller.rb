class GoogleAuthController < ApplicationController

  def callback
    state = JSON.parse(params[:state]) if params[:state].is_a?(String)
    integration_id = state.dig('integration', 'id')
    @integration = Integration.find_by(id: integration_id)
    
    handler = Integrations::Google::GoogleAuthHandler.new(@integration)
    response = handler.fetch_access_token(params[:code])
    handler.update_integration_tokens(response)

    redirect_to ENV['FRONTEND_REDIRECT_URI'], allow_other_host: true
  end

  def authenticate_user!
    if @integration.google_access_token.nil? || @integration.google_expires_at < Time.now
      state = { integration: @integration}
      handler = Integrations::Google::GoogleAuthHandler.new(@integration)
      render json: { authorization_uri: handler.authorization_uri(state) }
    end
  end
end
