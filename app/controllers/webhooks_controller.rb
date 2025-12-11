class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_webhook

  def verify_webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret, tolerance: 500
      )
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Stripe Webhook signature verification failed."
      head :forbidden 
    rescue JSON::ParserError => e
      Rails.logger.error "Stripe Webhook JSON parse error."
      head :bad_request 
    rescue => e
      Rails.logger.error "Error processing Stripe webhook: #{e.message}"
      head :internal_server_error 
    
  end
end
