module OrderManagement
  class << self
    # @param product_id [BSON::ObjectId] The ID of the product to be viewed or ordered
    # @return [Product] The product if found, otherwise nil
    # @return Product[:id] [BSON::ObjectId] The ID of the product
    # @return Product[:name] [String] The name of the product
    # @return Product[:category] [String] The category of the product
    # @return Product[:default_price] [Integer] The default price of the product
    # @return Product[:adjusted_price] [Integer] The adjusted price of the product if any. Defaults to :default_price
    def customer_views_product(product_id:)
      ViewProduct.call(product_id:)
    end

    # @param products_array [Array<Hash>] Array of products with :product_id, :quantity, and :price keys
    # @param products_array[:product_id] [BSON::ObjectId] The ID of the product to be ordered
    # @param products_array[:quantity] [Integer] The quantity of the product to be
    # @param products_array[:price] [Integer] The price of the product to be ordered
    # Example: [{ product_id: BSON::ObjectId('...'), quantity: 2, price: 1000 }, ...]
    # @return [Order] The created order
    # @return Order[:id] [BSON::ObjectId] The ID of the order
    # @return Order[:total_price] [Integer] The total price of the order
    # @return Order[:order_items] [Array<Hash>] The array of products in the order
    # @return Order[:order_items][:product_id] [BSON::ObjectId]
    # @return Order[:order_items][:quantity] [Integer]
    # @return Order[:order_items][:price] [Integer]
    def customer_places_order(products_array:)
      PlaceOrder.call(products_array:)
    end
  end
end
