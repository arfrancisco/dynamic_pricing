module PricingManagement
  class << self
    def system_updates_adjusted_prices
      UpdateProductPrices.call
    end
  end
end
