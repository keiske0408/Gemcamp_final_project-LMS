# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < Admin::BaseController
  def index
    @q = Order.joins(:user, :offer)
              .filter_by_serial_number(params[:serial_number])
              .filter_by_email(params[:email])
              .filter_by_genre(params[:genre])
              .filter_by_state(params[:state])
              .filter_by_offer(params[:offer_id])
              .filter_by_date_range(params[:start_date], params[:end_date])

    @orders = @q.page(params[:page]).per(5)

    # Subtotal for the current page
    @subtotal = @orders.sum(:amount) + @orders.sum(:coins)

    # Total for all filtered records
    @total = @q.sum(:amount) + @q.sum(:coins)
  end

  def pay
    order = Order.find(params[:id])
    order.pay!
    redirect_to admin_orders_path, notice: "Order ##{order.serial_number} marked as paid."
  end

  def cancel
    order = Order.find(params[:id])
    order.revert_payment!
    redirect_to admin_orders_path, notice: "Order ##{order.serial_number} marked as cancelled."
  end


end
