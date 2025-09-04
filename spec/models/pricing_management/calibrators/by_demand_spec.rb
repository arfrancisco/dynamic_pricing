# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricingManagement::Calibrators::ByDemand do
  let(:product) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity: 100) }

  context 'when demand is high' do
    before do
      FactoryBot.create_list(:order, 10,
        order_items: [
          FactoryBot.create(:order_item, product_id: product.id, quantity: 15)
        ]
      )
    end

    it 'returns the increase ratio' do
      calibrator = described_class.new(product:)
      expect(calibrator.call).to eq(0.05)
    end
  end

  context 'when demand is low' do
    before do
      FactoryBot.create_list(:order, 5,
        order_items: [
          FactoryBot.create(:order_item, product_id: product.id, quantity: 1)
        ]
      )
    end

    it 'returns the decrease ratio' do
      calibrator = described_class.new(product:)
      expect(calibrator.call).to eq(-0.05)
    end
  end

  context 'when demand is neither high nor low' do
    before do
      FactoryBot.create_list(:order, 5,
        order_items: [
          FactoryBot.create(:order_item, product_id: product.id, quantity: 5)
        ]
      )
    end

    it 'returns zero' do
      calibrator = described_class.new(product:)
      expect(calibrator.call).to eq(0.0)
    end
  end
end
