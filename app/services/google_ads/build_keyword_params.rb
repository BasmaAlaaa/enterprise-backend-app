require 'google/ads/google_ads'

module GoogleAds
  class BuildKeywordParams
    include Interactor

    delegate :location_ids, :keywords, :page_url, :fail!, to: :context
    
    def call
      validate_input!
      context.options_hash = build_options_hash
      context.geo_target_constants = build_geo_target_constants
    end

    private

    def validate_input!
      if empty_or_nil?(keywords&.reject(&:nil?)) && page_url.nil?
        fail!(errors: ["At least one of keywords or page URL is required."])
      end
    end

    def build_options_hash
      return {url_seed: build_url_seed} if empty_or_nil?(keywords)
      return {keyword_seed: build_keyword_seed} if page_url.nil?
    
      build_keyword_and_url_seed
    end

    def build_url_seed
      client.resource.url_seed { |s| s.url = page_url }
    end
    
    def build_keyword_seed
      client.resource.keyword_seed do |s|
        keywords&.each { |keyword| s.keywords << keyword }
      end
    end

    def build_keyword_and_url_seed
      client.resource.keyword_and_url_seed do |s|
        s.url = page_url
        keywords&.each { |keyword| s.keywords << keyword }
      end
    end

    def build_geo_target_constants
      location_ids.map { |id| client.path.geo_target_constant(id) }
    end

    def client
      @client ||= Google::Ads::GoogleAds::GoogleAdsClient.new('config/google_ads.rb')
    end

    def empty_or_nil?(array)
      return true if array.nil?

      array.empty?
    end
  end
end