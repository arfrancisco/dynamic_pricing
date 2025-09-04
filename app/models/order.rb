class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :order_items, class_name: 'OrderItem'

  field :email, type: String
  field :total_price, type: Integer
end
