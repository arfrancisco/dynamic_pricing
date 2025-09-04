class ProductsController < ApplicationController
  def show
    product = ::OrderManagement.customer_views_product(product_id: permitted_params[:product_id])

    render json: product, status: :ok
  rescue OrderManagement::ViewProduct::ProductNotFoundError => e
    render json: { errors: [{ code: :not_found, message: e.message }] }, status: :not_found
  end

  private

  def permitted_params
    params.permit(:product_id)
  end
end
