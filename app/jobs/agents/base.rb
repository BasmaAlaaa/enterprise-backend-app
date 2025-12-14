# frozen_string_literal: true

module Agents
  class Base
    include Sidekiq::Job

    private

    def fetch_llm_response(prompt:, user_id:, shop_id:, api_end_point:,customer_uid: nil, onboarded: false, shop_domain: nil, country: nil, currency: nil, ac_count: nil, shop_name: nil, initial_segment_id: nil, initial_segment_id_wf: nil)
      @shop_id = shop_id
      uri = URI("#{ENV.fetch('LLM_API_URL')}/#{api_end_point}")
      http = build_http(uri)
      request = build_request(uri, prompt, user_id, shop_id.to_s, customer_uid, onboarded, country, currency, ac_count, shop_name, initial_segment_id, initial_segment_id_wf, shop_domain)

      response = http.request(request)
      parse_response(response.body)
    rescue StandardError => e
      Rails.logger.error("LLM API error: #{e.class} - #{e.message}")
      nil
    end

    def build_http(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = (uri.scheme == 'https')
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    def build_request(uri, prompt, user_id, shop_id, customer_uid, onboarded, country, currency, ac_count, shop_name, initial_segment_id, initial_segment_id_wf, shop_domain)
      Net::HTTP::Post.new(uri.path).tap do |req|
        req['Content-Type'] = 'application/json'
        req.body = {
          prompt: prompt,
          user_id: user_id,
          shop_id: shop_id,
          customer_uid: customer_uid,
          onboarded: onboarded,
          country: country,
          currency: currency,
          ac_count: ac_count,
          shop_name: shop_name,
          initial_segment_id: initial_segment_id,
          initial_segment_id_wf: initial_segment_id_wf,
          shop_domain: shop_domain
        }.to_json
      end
    end

    def parse_response(body)
      JSON.parse(body)
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parse error: #{e.message}")
      nil
    end

    def push_to_firebase(shop, message, agent_type)
      FirebaseApi.new(shop, agent_type).push_message(text: message, role: 'agent')
    end

    def shop
      @shop ||= Shop.find(@shop_id)
    end
  end
end
