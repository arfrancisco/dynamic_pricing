module OrderManagement
  class PlaceOrder
    InvalidArgumentError = Class.new(StandardError)
    ProductNotFoundError = Class.new(StandardError)
    InsufficientStockError = Class.new(StandardError)

    SUPPORTED_ARGUMENTS = [
      :product_id,
      :quantity,
      :price,
    ].freeze

    attr_reader :products_array

    def self.call(products_array:)
      new(products_array:).call
    end

    def initialize(products_array:)
      @products_array = products_array
    end

    def call
      validate_arguments
      normalize_arguments
      validate_products
      create_order
    end

    private

    def validate_arguments
      raise InvalidArgumentError, "products_array must be an array of hashes" unless products_array.is_a?(Array)

      # Check if each item has all required keys
      products_array.each do |item|
        unless SUPPORTED_ARGUMENTS.all? { |key| item.key?(key) }
          raise InvalidArgumentError, "Each product must contain the keys: #{SUPPORTED_ARGUMENTS.join(', ')}"
        end
      end

      # Check if the expected number fields are actually numbers
      products_array.each do |item|
        unless item[:quantity].numeric?
          raise InvalidArgumentError, "Quantity must be a number for product ID #{item[:product_id]}"
        end

        unless item[:price].numeric?
          raise InvalidArgumentError, "Price must be a number for product ID #{item[:product_id]}"
        end
      end
    end

    def normalize_arguments
      @products_array = products_array.map do |item|
        {
          product_id: item[:product_id],
          quantity: item[:quantity].to_i,
          price: item[:price].to_i
        }
      end
    end

    def validate_products
      products_array.each do |order_item|
        product = Product.where(id: order_item[:product_id]).first

        raise ProductNotFoundError, "Product with ID #{order_item[:product_id]} not found" unless product
        raise InsufficientStockError, "Insufficient stock for product ID #{order_item[:product_id]}" if product.quantity < order_item[:quantity]
      end
    end

    def create_order
      order = Order.create
      products_array.each do |order_item|
        product = Product.where(id: order_item[:product_id]).first

        order.order_items.create!(
          product_id: product.id,
          quantity: order_item[:quantity],
          price: order_item[:price]
        )

        product.quantity -= order_item[:quantity]
        product.save!
      end

      order.update!(total_price: order.order_items.sum { |item| item.quantity * item.price })
      order
    end
  end
end
