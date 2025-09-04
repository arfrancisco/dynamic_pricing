# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricingManagement::Calibrators::ByInventoryLevel do
  let(:product) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity:) }

  context 'when inventory level is low' do
    let(:quantity) { 5 }

    it 'returns the increase ratio' do
      calibrator = described_class.new(product:)
      expect(calibrator.call).to eq(0.05)
    end
  end

  context 'when inventory level is high' do
    let(:quantity) { 100 }

    it 'returns the decrease ratio' do
      calibrator = described_class.new(product:)
      expect(calibrator.call).to eq(-0.05)
    end
  end
end
