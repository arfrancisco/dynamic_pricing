FactoryBot.define do
  factory :order_item do
    association :order

    product_id { '234lkj234rlkj23' }
    name { 'coffee' }
    quantity { 2 }
    price { 80 }
  end
end
