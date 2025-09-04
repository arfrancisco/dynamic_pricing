# README

## Setup
The easiest way to set this all up is by using Docker. I've provided a recipe so that docker would just build everything and all we need to do is run the server and seed the data
```
$ cd dynamic_pricing
$ docker-compose build --no-cache
$ docker-compose up
```
By this point the app should be running and we can check http://localhost:3000 on our local. We just need to seed the data
```
$ docker-compose exec web rake db:create 
$ docker-compose exec web rake db:seed
```

## How it all works

### API
We have two endpoints for this:
`GET /products/:product_id`
This just accepts the unique product id and returns json response with this format:
```
{
  id: String,
  name: String,
  category: String,
  default_price: Integer,
  adjusted_price: Integer
}
```

- `POST /orders`
This one accepts a post request with the email of the customer and an array of order items:
```
{
  email: String,
  order_items: [
    {
      product_id: String,
      quantity: Integer,
      price: Integer,
    }
  ]
}
```
The response will be the created order itself:
```
  {
    _id: String,
    created_at: String timestamp,
    updated_at: String timestamp,
    email: String,
    total_price: Integer,
    order_items: Array of hashes
      [{
        _id: String,
        created_at: String timestamp,
        updated_at: String timestamp,
        name: String,
        price: Integer,
        quantity: Integer, 
        product_id: String
      }] 
  }
```

### Order Management module
We have the `OrderManagement` module that acts as the interface for the controllers. The methods represents the possible actions that can be done. The classes under it are all contained under the same directory so that it's obvious that they are part of the same feature. We only have two methods under it for now. Just a way for customers to view product details and another to place an order. This is the module that gets called with the endpoints discussed above.

### Pricing Managent module
The `PricingManagement` module houses the classes responsible for updating the prices. This is currently being used a rake task (`rake pricing_management:update_prices`) which can be scheduled to be ran via cron at any interval we want. The rake task will schedule a sidekiq job which will ultimately call the `PricingManagement.system_updates_adjusted_prices` method. 

Now we need to explain how the pricing update works. In a nutshell, It goes through all the products and run them through multiple calibration classes that return a percentage value that we use to increase or decrease the default price.
We currently have three calibration classes that can be configured as necessary depending on requirements. They also follow a common pattern so that it's easy to add more calibration classes in the future.
These are the classes:
- `PricingManagement::Calibrators::ByDemand`
- `PricingManagement::Calibrators::ByInventoryLevel`
- `PricingManagement::Calibrators::ByMarketPrices`

They can all be configured on what we consider the thresholds should be and how much the increase or decrease we want. 

`PricingManagement::Calibrators::ByDemand` has an upper and lower threshold to consider as high or low demand. We can also configure the date range of orders to consider when considering demand. Lastly the increase and decrease ratios can also be configured. 

`PricingManagement::Calibrators::ByInventoryLevel` has an upper and lower threshold to consider as high or low inventory count. The increase and decrease ratios can also be configured.

`PricingManagement::Calibrators::ByMarketPrices` has just one threshold. We check the percent difference of our product with the market price and would only try to increase or decrease the price if the percentage difference is above the threshold. Again the increase and decrease ratios can also be configured.

