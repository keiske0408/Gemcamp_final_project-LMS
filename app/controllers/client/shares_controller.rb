class Client::SharesController < ApplicationController
  before_action :authenticate_client!
  before_action :set_winner, only: [:new, :create]

  def new
    # @feedback = @winner.build_feedback
    redirect_to winning_history_client_me_path, alert: "Invalid winner record." unless @winner.delivered?
  end

  def create
    if @winner.update(share_params)
      @winner.share!
      # (share_params.merge(state: "shared"))
      flash[:notice] = "Thank you for sharing your feedback!"
      redirect_to winning_history_client_me_path
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new
    end
  end

  private

  def set_winner
    @winner = Winner.find_by(user: current_client)
  end

  def share_params
    params.require(:winner).permit(:picture, :comment)
  end
end