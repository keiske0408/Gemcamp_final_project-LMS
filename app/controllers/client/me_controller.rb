class Client::MeController < ApplicationController
  before_action :authenticate_client!

  def show
    # Display user profile information
  end

  def order_history
    @orders = current_client.orders.order(created_at: :desc).page(params[:page]).per(8)
  end

  def lottery_history
    @tickets = current_client.tickets.order(created_at: :desc).page(params[:page]).per(8)
  end

  def invitation_history
    @invited_members = User.where(parent_id: current_client.id).order(created_at: :desc).page(params[:page]).per(8)
  end

  def winning_history
    @winnings = Winner.where(user_id: current_client.id).order(created_at: :desc).page(params[:page]).per(8)
  end


  def claim_prize
    user = User.find(current_client.id)
    winner = Winner.where(user: current_client).find(params[:winner_id])

    if params[:winner][:locations].blank?
      flash[:alert] = "No address selected. Please select an address."
      return redirect_to winning_history_client_me_path
    end

    location = user.locations.find(params[:winner][:locations])

    if winner.may_claim?
      winner.claim!
      winner.update(location_id: location.id)
      flash[:notice] = "Prize claimed successfully!"
    else
      flash[:alert] = "Unable to claim prize."
    end
    redirect_to winning_history_client_me_path
  end

  def cancel_order
    order = current_client.orders.find(params[:id])

    if order.submitted?
      order.cancel!
      flash[:notice] = 'Your order has been successfully canceled.'
    else
      flash[:alert] = 'Order cannot be canceled at this stage.'
    end

    redirect_to order_history_client_me_path
  end

end
  

