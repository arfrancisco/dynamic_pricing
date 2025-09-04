# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricingManagement::FetchMarketPrices do
  describe '#call' do
    let(:response) do
      [
        { name: 'coffee', category: 'drinks', price: 100, qty: 50 },
        { name: 'tea', category: 'drinks', price: 80, qty: 30 }
      ]
    end

    it 'attempts to fetch market prices from the external API' do
      allow(PricingManagement::FetchMarketPrices).to receive(:api_key).and_return('test_api_key')
      allow(Net::HTTP).to receive(:get).and_return(response.to_json)

      result = described_class.call

      expect(result).to eq([
        { name: 'coffee', category: 'drinks', price: 100, qty: 50 },
        { name: 'tea', category: 'drinks', price: 80, qty: 30 }
      ])
    end

    it 'returns an empty array if the API call fails' do
      allow(Net::HTTP).to receive(:get).and_raise(StandardError.new('API error'))

      result = described_class.call

      expect(result).to eq([])
    end
  end
end
