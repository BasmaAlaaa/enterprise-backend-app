class RefreshSallaTokensJob
  include Sidekiq::Job

  def perform
    Integration.where(integration_type: 'salla').find_each do |integration|
      Integrations::Salla::RefreshToken.call(integration: integration)
    end
  end
end
