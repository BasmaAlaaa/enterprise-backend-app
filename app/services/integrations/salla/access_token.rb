module Integrations
  module Salla
    class AccessToken
      include Interactor

      delegate :domain, :access_token, :merchant_id, :refresh_token, to: :context

      def call
        integration = Integration.find_or_create_by(integration_type: 'salla', domain: domain, merchant_id: merchant_id)
        if integration.update(token: access_token, refresh_token: refresh_token, is_installed: true)
          create_statistics!(integration) unless integration.statistics.present?
          context.integration = integration
        else
          context.fail!(errors: integration.errors.full_messages)
        end
      end

      private

      def create_statistics!(integration)
        Statistics.create(integration: integration)
      end
    end
  end
end