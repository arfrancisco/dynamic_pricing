require 'csv'

inventory = File.read('./db/inventory.csv')
csv = CSV.parse(inventory, headers: true, header_converters: :symbol)

# headers are :name, :category, :default_price, :qty
csv.each do |row|
  Product.create(
    name: row[:name],
    category: row[:category],
    default_price: row[:default_price],
    quantity: row[:qty]
  )
end
