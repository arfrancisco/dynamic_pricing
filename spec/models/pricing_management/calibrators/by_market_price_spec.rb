# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricingManagement::Calibrators::ByMarketPrice do
  let(:product) { FactoryBot.create(:product, name: 'coffee', category: 'drinks', default_price: 100, adjusted_price: 80, quantity: 100) }

  context 'when there is no market price data' do
    it 'returns zero adjustment' do
      calibrator = described_class.new(product:, market_prices: {})
      expect(calibrator.call).to eq(0.0)
    end
  end

  context 'when market price equals adjusted price' do
    let(:market_prices) do
      [{
        name: 'coffee',
        category: 'drinks',
        price: 100,
        qty: 50
      }]
    end

    it 'returns zero adjustment' do
      calibrator = described_class.new(product:, market_prices:)
      expect(calibrator.call).to eq(0.0)
    end
  end

  context 'when market price is within our threshold' do
    let(:market_prices) do
      [{
        name: 'coffee',
        category: 'drinks',
        price: 96,
        qty: 50
      }]
    end

    it 'returns zero adjustment' do
      calibrator = described_class.new(product:, market_prices:)
      expect(calibrator.call).to eq(0.0)
    end
  end

  context 'when market price percentage difference is above our threshold' do
    context 'when market price is higher than our price' do
      let(:market_prices) do
        [{
          name: 'coffee',
          category: 'drinks',
          price: 106,
          qty: 50
        }]
      end

      it 'returns positive adjustment' do
        calibrator = described_class.new(product:, market_prices:)
        expect(calibrator.call).to eq(0.06)
      end
    end

    context 'when market price is lower than our price' do
      let(:market_prices) do
        [{
          name: 'coffee',
          category: 'drinks',
          price: 70,
          qty: 50
        }]
      end

      it 'returns negative adjustment' do
        calibrator = described_class.new(product:, market_prices:)
        expect(calibrator.call).to eq(-0.06)
      end
    end
  end
end
