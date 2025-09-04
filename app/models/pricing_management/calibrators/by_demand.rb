module PricingManagement
  module Calibrators
    class ByDemand
      # This class will recommend price adjustments based on how often a product is ordered.
      # We can configure the date range of orders to consider, the thresholds for high and low demand,
      # and the adjustment ratios.

      attr_reader :product

      def self.price_adjustment_ratio(product:)
        new(product:).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        if quantity_ordered >= upper_threshold
          increase_ratio
        elsif quantity_ordered <= low_threshold
          decrease_ratio
        end
      end

      private

      def quantity_ordered
        @quantity_ordered ||= Order.where('order_items.product_id' => product.id, created_at: date_range)
          .sum { |order| order.order_items.where(product_id: product.id).sum(&:quantity) }
      end

      def date_range
        10.days.ago.beginning_of_day..Time.current.end_of_day
      end

      # Quantity of orders in the date range above to consider a product "high demand"
      def upper_threshold
        100
      end

      # Quantity of orders in the date range below to consider a product "low demand"
      def low_threshold
        10
      end

      # percentage to increase price by for high demand products
      # This is a 5% increase
      def increase_ratio
        0.05
      end

      # percentage to decrease price by for low demand products
      # This is a 5% decrease
      def decrease_ratio
        -0.05
      end
    end
  end
end
