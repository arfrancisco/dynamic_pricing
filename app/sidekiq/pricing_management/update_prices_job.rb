class PricingManagement::UpdatePricesJob
  include Sidekiq::Job

  def perform
    ::PricingManagement.system_updates_adjusted_prices
  end
end
