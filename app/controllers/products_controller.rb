class ProductsController < ApplicationController
  def show
    product = ::OrderManagement.customer_views_product(product_id: params[:product_id])

    render json: product
  rescue OrderManagement::ViewProduct::ProductNotFoundError => e
    render json: { errors: [{ code: :not_found, message: e.message }] }, status: :not_found
  end
end
