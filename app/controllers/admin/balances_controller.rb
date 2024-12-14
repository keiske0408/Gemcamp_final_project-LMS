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
      redirect_to admin_users_path
    else
      flash[:error] = @order.errors.full_messages.to_sentence
      render :new_member_level
    end
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
      redirect_to admin_users_path
    else
      flash[:error] = @order.errors.full_messages.to_sentence
      render :new_increase
    end
  end

  def new_deduct
    @order = Order.deduct.new
  end

  def create_deduct_order
    @order = @user.orders.deduct.new(order_params)

    if @order.coin <= @user.coins
      if @order.save && @order.may_pay?
        @order.pay!
        @order.update(state: "cancelled")
        flash[:success] = "Deduct order created and payment processed successfully."
        redirect_to admin_users_path
      else
        flash.now[:alert] = "Failed to process the deduct order. Please try again."
        render :new_deduct
      end
    else
      @order.cancel! if @order.persisted?
      flash.now[:alert] = "Insufficient coins. Order was cancelled."
      render :new_deduct
    end
  end


  def new_bonus
    @order = Order.bonus.new
  end

  def create_bonus
    @order = @user.orders.bonus.new(order_params)

    if @order.save && @order.may_pay?
      @order.pay!
      flash[:success] = "Deduct order created and payment processed successfully."
      redirect_to admin_users_path
    else
      flash[:alert] = @order.errors.full_messages.to_sentence
      render :new_bonus
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:coin, :amount, :remarks)
  end
end