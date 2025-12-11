class Webhooks::ShopifyController < WebhooksController
  skip_before_action :verify_webhook

    def shop_redact
        Integration.find_by(domain: params[:shop_domain]).destroy
        head :no_content
    end

    def data_request
        render json: {message: "we have no access on customers' data"}
    end

    def customer_redact
        render json: {message: "we have no access on customers' data"}
    end
  end