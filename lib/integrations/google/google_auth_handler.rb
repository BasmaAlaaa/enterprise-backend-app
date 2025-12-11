require 'google/apis/webmasters_v3'
require 'google/apis/indexing_v3'
require 'signet/oauth_2/client'
module Integrations
  module Google
    class GoogleAuthHandler
      WEBMASTERS_SCOPE = 'https://www.googleapis.com/auth/webmasters.readonly'.freeze
      INDEXING_SCOPE = 'https://www.googleapis.com/auth/indexing'.freeze

      def initialize(integration)
        @integration = integration
        @webmasters_service = ::Google::Apis::WebmastersV3::WebmastersService.new
        @indexing_service = ::Google::Apis::IndexingV3::IndexingService.new
      end

      def authorization_uri(state)
        client = Signet::OAuth2::Client.new({
          client_id: ENV['GOOGLE_ADS_CLIENT_ID'],
          client_secret: ENV['GOOGLE_ADS_CLIENT_SECRET'],
          authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
          scope: [
            WEBMASTERS_SCOPE,
            INDEXING_SCOPE
          ],
          redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
          access_type: 'offline',
          prompt: 'consent',
          state: state.to_json
        })
        client.authorization_uri.to_s
      end

      def fetch_access_token(code)
        client = Signet::OAuth2::Client.new({
          client_id: ENV['GOOGLE_ADS_CLIENT_ID'],
          client_secret: ENV['GOOGLE_ADS_CLIENT_SECRET'],
          token_credential_uri: 'https://oauth2.googleapis.com/token',
          redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
          code: code
        })
        client.fetch_access_token!
      end

      def update_integration_tokens(response)
        @integration.update(
          google_access_token: response['access_token'],
          google_refresh_token: response['refresh_token'],
          google_expires_at: Time.now + response['expires_in'].to_i.seconds
        )
      end

      def signout
        @integration.update(
          google_access_token: nil,
          google_refresh_token: nil,
          google_expires_at: nil
        )
      end

      def list_sites
        authorize_service(@webmasters_service, WEBMASTERS_SCOPE)
        @webmasters_service.list_sites
      rescue StandardError => e
        raise "Error listing sites: #{e.message}" 
      end

      def query_search_analytics(url, request)
        authorize_service(@webmasters_service, WEBMASTERS_SCOPE)
        @webmasters_service.query_search_analytics(url, request)
      rescue ::Google::Apis::ClientError => e
        if e.status_code == 403
          {error: 'User does not have sufficient permissions for this site.', status: :forbidden}
        else
          {error: e.message, status: e.status_code}
        end
      rescue StandardError => e
        {error: e.message, status: :internal_server_error}
      end

      def handle_response(result)
        if result.success?
          { json: result.response, status: :ok }
        else
          { json: { error: result.error }, status: result.status }
        end
      end

      private

      attr_reader :integration

      def authorize_service(service, scope)
        client = Signet::OAuth2::Client.new(
          client_id: ENV['GOOGLE_ADS_CLIENT_ID'],
          client_secret: ENV['GOOGLE_ADS_CLIENT_SECRET'],
          token_credential_uri: 'https://oauth2.googleapis.com/token',
          access_token: @integration.google_access_token,
          refresh_token: @integration.google_refresh_token,
          scope: scope
        )

        if @integration.google_expires_at < Time.now
          client.refresh!
          @integration.update(
            google_access_token: client.access_token,
            google_refresh_token: client.refresh_token,
            google_expires_at: Time.now + client.expires_in
          )
        end

        service.authorization = client
      end
    end
  end
end