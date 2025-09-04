class OrdersController < ApplicationController
  def create
    order = ::OrderManagement::PlaceOrder.call(products_array: permitted_params[:products_array])

    render json: order, status: :ok
  rescue OrderManagement::PlaceOrder::InvalidArgumentError => e
    render json: { errors: [{ code: :invalid_argument, message: e.message }] }, status: :bad_request
  rescue OrderManagement::PlaceOrder::ProductNotFoundError => e
    render json: { errors: [{ code: :not_found, message: e.message }] }, status: :not_found
  rescue OrderManagement::PlaceOrder::InsufficientStockError => e
    render json: { errors: [{ code: :insufficient_stock, message: e.message }] }, status: :bad_request
  end

  private

  def permitted_params
    params.permit(products_array: [:product_id, :quantity, :price])
  end
end
