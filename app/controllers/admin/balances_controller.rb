class Admin::BalancesController < Admin::BaseController
  before_action :set_user

  def new_member_level
    @order = Order.member_level.new
  end

  def update_member_level
    @order = @user.orders.member_level.new(order_params)

    if @order.save && @order.may_pay?
      @order.pay!
      flash[:success] = "Coins successfully rewarded!"
    else
      flash[:error] = @order.errors.full_messages.to_sentence
    end
    redirect_to admin_users_path
  end

  def new_increase
    @order = Order.increase.new
    # @genre = :increase?
  end
  def create_increase
    @order = @user.orders.increase.new(order_params)

    if @order.save && @order.may_pay?
      @order.pay!
      flash[:success] = "Coins successfully increased!"
    else
      flash[:error] = @order.errors.full_messages.to_sentence
    end
    redirect_to admin_users_path
  end

  def new_deduct
    @order = Order.deduct.new
  end

  def create_deduct_order
    @order = @user.orders.deduct.new(order_params)

    if @order.coin <= @user.coins
      if @order.save && @order.may_pay?
        @order.pay!
        flash[:success] = "Deduct order created and payment processed successfully."
      else
        flash[:alert] = "Failed to process the deduct order. Please try again."
      end
    else
      @order.cancel! if @order.persisted?
      flash[:alert] = "Insufficient coins. Order was cancelled."
    end

    redirect_to admin_users_path
  end

  def new_bonus
    @order = Order.bonus.new
  end

  def create_bonus
    @order = @user.orders.bonus.new(order_params)

    if @order.save && @order.may_pay?
      @order.pay!
      flash[:success] = "Deduct order created and payment processed successfully."
    else
      flash[:alert] = @order.errors.full_messages.to_sentence
    end
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:coin, :amount, :remarks)
  end
end