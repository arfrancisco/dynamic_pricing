# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderManagement::PlaceOrder do
  describe '.call' do
    subject(:place_order) { described_class.call(products_array:) }

    let(:coffee) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity: 100) }
    let(:tea) { FactoryBot.create(:product, name: 'tea', category: 'drinks', default_price: 50, adjusted_price: 40, quantity: 50) }

    context 'when all arguments are valid and products have sufficient supply and exists' do
      let(:products_array) do
        [
          { product_id: coffee.id, quantity: 2, price: 80 },
          { product_id: tea.id, quantity: 3, price: 40 }
        ]
      end

      it 'returns the total price and updates product quantities' do
        order = place_order

        expect(order.total_price).to eq(280) # (2 * 80) + (3 * 40) = 160 + 120 = 280

        expect(coffee.reload.quantity).to eq(98) # 100 - 2
        expect(tea.reload.quantity).to eq(47)    # 50 - 3
      end
    end

    context 'when a product does not exist' do
      let(:products_array) do
        [
          { product_id: coffee.id, quantity: 2, price: 80 },
          { product_id: 0, quantity: 3, price: 40 } # Non-existent product
        ]
      end

      it 'raises a ProductNotFoundError' do
        expect { place_order }.to raise_error(OrderManagement::PlaceOrder::ProductNotFoundError, 'Product with ID 0 not found')
      end

      it 'does not change product quantities' do
        place_order rescue nil

        expect(coffee.reload.quantity).to eq(100)
        expect(tea.reload.quantity).to eq(50)
      end
    end

    context 'when a product has insufficient quantity' do
      let(:products_array) do
        [
          { product_id: coffee.id, quantity: 200, price: 80 }, # Exceeds available quantity
          { product_id: tea.id, quantity: 3, price: 40 }
        ]
      end

      it 'raises an InsufficientStockError' do
        expect { place_order }.to raise_error(OrderManagement::PlaceOrder::InsufficientStockError, "Insufficient stock for product ID #{coffee.id}")
      end

      it 'does not change product quantities' do
        place_order rescue nil

        expect(coffee.reload.quantity).to eq(100)
        expect(tea.reload.quantity).to eq(50)
      end
    end

    context 'when arguments are invalid' do
      let(:products_array) { 'invalid_argument' }

      it 'raises an InvalidArgumentError' do
        expect { place_order }.to raise_error(OrderManagement::PlaceOrder::InvalidArgumentError, 'products_array must be an array of hashes')
      end

      context 'when a product hash is missing required keys' do
        let(:products_array) do
          [
            { product_id: coffee.id, quantity: 2 }, # Missing :price key
            { product_id: tea.id, quantity: 3, price: 40 }
          ]
        end

        it 'raises an InvalidArgumentError' do
          expect { place_order }.to raise_error(OrderManagement::PlaceOrder::InvalidArgumentError, 'Each product must contain the keys: product_id, quantity, price')
        end
      end

      context 'when quantity is not a number' do
        let(:products_array) do
          [
            { product_id: coffee.id, quantity: 'two', price: 80 }, # Invalid quantity
            { product_id: tea.id, quantity: 3, price: 40 }
          ]
        end

        it 'raises an InvalidArgumentError' do
          expect { place_order }.to raise_error(OrderManagement::PlaceOrder::InvalidArgumentError, "Quantity must be a number for product ID #{coffee.id}")
        end
      end

      context 'when price is not a number' do
        let(:products_array) do
          [
            { product_id: coffee.id, quantity: 2, price: 'eighty' }, # Invalid price
            { product_id: tea.id, quantity: 3, price: 40 }
          ]
        end

        it 'raises an InvalidArgumentError' do
          expect { place_order }.to raise_error(OrderManagement::PlaceOrder::InvalidArgumentError, "Price must be a number for product ID #{coffee.id}")
        end
      end
    end
  end
end
