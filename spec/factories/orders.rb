FactoryBot.define do
  factory :order do
    email { 'test@mailer.com' }
    total_price { 100 }
  end
end
