module OrderManagement
  class ViewProduct
    ProductNotFoundError = Class.new(StandardError)

    def self.call(product_id:)
      new(product_id:).call
    end

    def initialize(product_id:)
      @product_id = product_id
    end

    def call
      raise ProductNotFoundError, "Product with ID #{@product_id} not found" unless product

      {
        id: product.id,
        name: product.name,
        category: product.category,
        default_price: product.default_price,
        adjusted_price: product.adjusted_price || product.default_price
      }
    end

    private

    def product
      @product ||= Product.where(id: @product_id).first
    end
  end
end
