module PricingManagement
  module Calibrators
    class ByMarketPrice
      # This class will recommend price adjustments based on market prices.
      # We can configure the thresholds for how far above or below our current prices match with the market price.
      # We can also set the adjustment ratios.
      attr_reader :product, :market_prices

      def self.price_adjustment_ratio(product:, market_prices:)
        new(product:, market_prices:).call
      end

      def initialize(product:, market_prices:)
        @product = product
        @market_prices = market_prices
      end

      def call
        # If there's no similar product in the market prices, do nothing
        # If the prices are the same, do nothing
        # If the prices are within our threshold percentage, do nothing
        # If our price is more than our threshold above the market price, decrease it
        # If our price is more than our threshold below the market price, increase it

        return 0 unless similar_product_market_price
        return 0 if similar_product_market_price == product.default_price
        return 0 if percent_difference <= threshold

        if product.default_price > similar_product_market_price
          decrease_ratio
        else
          increase_ratio
        end
      end

      private

      def similar_product_market_price
        @similar_product_market_price ||= market_prices.find { |mp_item| mp_item[:name] == product.name }&.dig(:price)
      end

      def percent_difference
        return 0 unless similar_product_market_price

        ((product.default_price - similar_product_market_price).abs / similar_product_market_price.to_f) * 100
      end

      # Threshold percentage difference to consider adjusting price
      # This is a 5% difference
      def threshold
        5.0
      end

      # percentage to increase price when our price is below market price
      # This is a 6% increase
      def increase_ratio
        0.06
      end

      # percentage to decrease price when our price is above market price
      # This is a 6% decrease
      def decrease_ratio
        -0.06
      end
    end
  end
end
