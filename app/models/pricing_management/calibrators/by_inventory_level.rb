module PricingManagement
  module Calibrators
    class ByInventoryLevel
      # This class will recommend price adjustments based on current inventory levels.
      # We can configure the thresholds for high and low levels and the adjustment ratios.

      attr_reader :product

      def self.price_adjustment_ratio(product:)
        new(product:).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        if product.quantity >= upper_threshold
          decrease_ratio
        elsif product.quantity <= lower_threshold
          increase_ratio
        else
          0
        end
      end

      private

      # Quantity of inventory above to consider a product "high inventory"
      def upper_threshold
        100
      end

      # Quantity of inventory below to consider a product "low inventory"
      def lower_threshold
        10
      end

      # percentage to increase price for low inventory products
      # This is a 5% increase
      def increase_ratio
        0.05
      end

      # percentage to decrease price for high inventory products
      # This is a 5% decrease
      def decrease_ratio
        -0.05
      end
    end
  end
end
