require 'google/ads/google_ads'

module GoogleAds
  class GenerateKeywordIdeas
    include Interactor

    delegate :language_id, :include_adult_keywords, :geo_target_constants, :options_hash, :fail!, to: :context
    
    def call
      response = fetch_keyword_ideas(geo_target_constants, options_hash)
      context.keyword_ideas = parse_response(response)
    end

    private

    def fetch_keyword_ideas(geo_target_constants, options_hash)
      client.service.keyword_plan_idea.generate_keyword_ideas(
        customer_id: customer_id,
        language: client.path.language_constant(language_id),
        geo_target_constants: geo_target_constants,
        include_adult_keywords: include_adult_keywords || true,
        keyword_plan_network: :GOOGLE_SEARCH_AND_PARTNERS,
        **options_hash
      )
    end

    def parse_response(response)
      response.map do |result|
        {
          text: result.text,
          monthly_searches: result.keyword_idea_metrics&.avg_monthly_searches || 0,
          competition: result.keyword_idea_metrics&.competition || :UNSPECIFIED,
          keyword_idea_metrics: parse_keyword_idea_metrics(result.keyword_idea_metrics),
        }
      end
    end

    def parse_keyword_idea_metrics(keyword_idea_metrics)
      return default_metrics if keyword_idea_metrics.blank?

      {
        low_top_of_page_bid_micros: keyword_idea_metrics.low_top_of_page_bid_micros,
        high_top_of_page_bid_micros: keyword_idea_metrics.high_top_of_page_bid_micros,
        competition_index: keyword_idea_metrics.competition_index,
        average_cpc: calculate_avg_cpc(keyword_idea_metrics.high_top_of_page_bid_micros, keyword_idea_metrics.low_top_of_page_bid_micros),
        monthly_search_volumes: map_monthly_search_volumes(keyword_idea_metrics.monthly_search_volumes)
      }
    end

    def default_metrics
      {
        low_top_of_page_bid_micros: 0,
        high_top_of_page_bid_micros: 0,
        competition_index: 0,
        average_cpc: 0,
        monthly_search_volumes: [],
      }
    end

    def calculate_avg_cpc(high, low)
      (high + low)/2
    end

    def map_monthly_search_volumes(monthly_search_volumes)
      monthly_search_volumes.map do |volume|
        {
          year: volume.year,
          month: volume.month,
          monthly_searches: volume.monthly_searches,
        }
      end
    end
    
    def customer_id
      @customer_id = ENV["GOOGLE_ADS_CUSTOMER_ID"]
    end

    def client
      @client ||= Google::Ads::GoogleAds::GoogleAdsClient.new('config/google_ads.rb')
    end
  end
end