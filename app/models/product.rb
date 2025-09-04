class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :category, type: String
  field :default_price, type: Integer
  field :adjusted_price, type: Integer
  field :quantity, type: Integer
end
