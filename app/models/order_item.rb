class OrderItem
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :order, class_name: 'Order'

  field :product_id, type: BSON::ObjectId
  field :name, type: String
  field :quantity, type: Integer
  field :price, type: Integer
end
