require 'net/http'
require 'json'

module PricingManagement
  class FetchMarketPrices
    API_ENDPOINT = 'https://sinatra-pricing-api.fly.dev/prices'.freeze

    class << self
      # Expected response format:
      # [
      #   {
      #     'name': String,
      #     'category': String,
      #     'price': Float,
      #     'qty': Integer
      #   }
      # ]
      def call
        parsed_response = JSON.parse(response)
        parsed_response.map(&:symbolize_keys)
      rescue StandardError => e
        Rails.logger.error("Failed to fetch market prices: #{e.message}")
        []
      end

      private

      def api_key
        ENV[:OUTSIDE_PRICING_API_KEY]
      end

      def uri
        URI(API_ENDPOINT + "?api_key=#{api_key}")
      end

      def response
        Net::HTTP.get(uri)
      end
    end
  end
end
