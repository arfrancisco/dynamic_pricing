# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricingManagement::UpdateProductPrices do
  describe '#call' do
    let!(:product) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity: 50) }

    before do
      allow(PricingManagement::Calibrators::ByDemand).to receive(:price_adjustment_ratio).and_return(0.05)
      allow(PricingManagement::Calibrators::ByInventoryLevel).to receive(:price_adjustment_ratio).and_return(-0.05)
      allow(PricingManagement::Calibrators::ByMarketPrice).to receive(:price_adjustment_ratio).and_return(0.06)
    end

    it 'updates product prices based on market data and calibrators' do
      described_class.call

      product.reload

      expect(product.adjusted_price).to eq(106)
    end
  end
end
