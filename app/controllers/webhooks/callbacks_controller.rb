class Webhooks::CallbacksController < WebhooksController
  skip_before_action :verify_webhook
  before_action :verify_signature, only: [:salla]

    def salla
      Rails.logger.info("Salla easy mode event: #{params}")
      return success if params[:event].blank?
      event = params[:event]
      data = params[:data]
      result = case event
        when "app.store.authorize"
          Rails.logger.info("Salla easy mode authorize event: #{data}")
          Integrations::Salla::Assign.call(access_token: data[:access_token], refresh_token: data[:refresh_token], merchant_id: params[:merchant])
        when "app.uninstalled"
          Integrations::HandleStoreUninstall.call(integration: @integration)
        when "app.subscription.started"
          Integrations::Salla::HandleStoreSubscriptionStarted.call(params: params, integration: @integration)
        # when "app.trial.started"
        #   SubscriptionPlans::AssignFreePlan.call(user: @account_owner)
        when "app.subscription.canceled"
          SubscriptionPlans::Cancel.call(user: @account_owner)
        when "app.subscription.renewed"
          SubscriptionPlans::Renew.call(user: @account_owner, subscription: @subscription)
        when "app.subscription.expired"
          SubscriptionPlans::SubscriptionExpired.call(integration: @integration)
        else
          render json: { message: "Invalid event" }, status: :ok
          return
      end
  
      if result.success?
        render json: { message: result.message || "Success" }, status: :ok
      else
        render json: { errors: result.errors }, status: :ok
      end
    end

    def shopify_direct_install
      url = "https://#{params[:shop]}/admin/oauth/authorize?client_id=#{ENV['SHOPIFY_API_KEY']}&response_type=code&redirect_uri=#{ENV['SHOPIFY_REDIRECT_URI']}&scope=read_products,read_content,read_product_listings,read_files,write_files,write_translations,read_locales,write_products,write_content&grant_options[]=offline_access"
      redirect_to url, allow_other_host: true
    end

    def shopify
      result = Integrations::Shopify::AccessToken.call(params: params)
      if result.success?
        create_statistics!(result.integration) unless result.integration.statistics.present?
        redirect_to "#{ENV["FRONTEND_REDIRECT_URI"]}?shop_domain=#{result.integration.domain}&shop_tokens=#{result.integration.token}", allow_other_host: true
      else
        render json: {errors: result}, status: :unprocessable_entity
      end
    end

    def wordpress
      integration = Integration.find_or_initialize_by(integration_type: 'wordpress', domain: params[:domain])
      if integration.update(token: params[:token])
        create_statistics!(integration) unless integration.statistics.present?
        render json: "Integration created successfully", status: :ok if integration.save
      else
        render json: {errors: integration.errors}, status: :unprocessable_entity
      end
    end

    private

    def create_statistics!(integration)
    Statistics.create(integration: integration)
    end

    def verify_signature
      return head :unauthorized unless valid_signature?
    end

    def valid_signature?
      request_body = request.raw_post
      secret = ENV["SALLA_WEBHOOK_SECRET"]
      signature = request.headers['X-Salla-Signature']
      return false unless signature 
      expected_signature = OpenSSL::HMAC.hexdigest('SHA256', secret, request_body)
      ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
    end
end