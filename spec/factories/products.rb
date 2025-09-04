FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    category { "Sample Category" }
    default_price { 100 }
    adjusted_price { 90 }
  end
end
