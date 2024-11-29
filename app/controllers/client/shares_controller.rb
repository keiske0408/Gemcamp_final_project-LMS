class Client::SharesController < ApplicationController
  before_action :authenticate_client!
  before_action :set_winner, only: [:edit , :update]

  def index
    @published_winners = Winner.where(state: 'published').order(created_at: :desc).page(params[:page]).per(3)
  end
  def edit
  end

  def update
    # render json: params
    if @winner.update(share_params)
      if @winner.delivered?
        @winner.share!
        flash[:notice] = "Thank you for sharing your feedback!"
        redirect_to winning_history_client_me_path
      else
        flash[:alert] = "This prize has already been shared."
        redirect_to winning_history_client_me_path
      end
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new
    end
  end


  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def share_params
    params.require(:winner).permit(:picture, :comment)
  end
end