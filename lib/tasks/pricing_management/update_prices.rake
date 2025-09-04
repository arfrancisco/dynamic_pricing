namespace :pricing_management do
  desc 'Update prices from external API'
  task update_prices: :environment do
    ::PricingManagement::UpdatePricesJob.perform_async
  end
end
