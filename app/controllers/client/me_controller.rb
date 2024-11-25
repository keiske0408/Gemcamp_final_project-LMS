class Client::MeController < ApplicationController
  before_action :authenticate_client!

  def show
    # Display user profile information
  end

  
  def order_history
    @orders = current_client.orders.page(params[:page]).per(5)
  end

  def lottery_history
    @tickets = current_client.tickets.page(params[:page]).per(5)
  end

  def invitation_history
    @invited_members = User.where(parent_id: current_client.id).page(params[:page]).per(5)
  end

  def winning_history
    @winnings = Winner.where(user_id: current_client.id).page(params[:page]).per(5)
  end

  def claim_prize
    @winner = Winner.find(params[:id])
    # Create a new address for the client if they don't have one
    @address = current_client.locations.build
  end

  def submit_address
    @winner = Winner.find(params[:winner_id])
    @address = current_client.addresses.new(address_params)

    if @address.save
      # Update the winner record status from 'won' to 'claimed'
      @winner.update(state: 'claimed')
      redirect_to client_me_path, notice: "Prize claimed successfully and address submitted!"
    else
      render :claim_prize
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip_code, :country)
  end
end
  

