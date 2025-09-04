require 'rails_helper'

RSpec.describe PricingManagement::UpdatePricesJob, type: :job do
  describe '#perform' do
    it 'calls the system_updates_adjusted_prices method' do
      expect(PricingManagement).to receive(:system_updates_adjusted_prices)
      described_class.new.perform
    end
  end
end
