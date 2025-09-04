module PricingManagement
  class UpdateProductPrices
    def self.call
      new.call
    end

    def call
      Product.each do |product|
        price_change_ratio = determine_price_change_ratio(product)

        adjusted_price = (product.default_price * price_change_ratio).round.to_i

        product.update(adjusted_price:)
      end
    end

    private

    def market_prices
      @market_prices ||= FetchMarketPrices.call
    end

    def determine_price_change_ratio(product)
      price_change_ratio = 1.00

      price_change_ratio += Calibrators::ByDemand.price_adjustment_ratio(product:)
      price_change_ratio += Calibrators::ByInventoryLevel.price_adjustment_ratio(product:)
      price_change_ratio += Calibrators::ByMarketPrice.price_adjustment_ratio(product:, market_prices:)

      price_change_ratio
    end
  end
end
