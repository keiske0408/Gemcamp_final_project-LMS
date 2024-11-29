class Admin::TicketsController < Admin::BaseController
  def index
    @tickets = Ticket.includes(:item, :user)

    # Filtering based on search params
    if params[:serial_number].present?
      @tickets = @tickets.where(serial_number:params[:serial_number])
    end

    if params[:item_name].present?
      @tickets = @tickets.joins(:item).where("items.name LIKE ?", "%#{params[:item_name]}%")
    end

    if params[:email].present?
      @tickets = @tickets.joins(:user).where("users.email LIKE ?", "%#{params[:email]}%")
    end

    if params[:state].present?
      @tickets = @tickets.where(state: params[:state])
    end

    if params[:start_date].present? && params[:end_date].present?
      @tickets = @tickets.where(created_at: params[:start_date]..params[:end_date])
    end
    @tickets = Ticket.page(params[:page]).per(10)
  end


  def cancel
    @ticket = Ticket.find(params[:id])
    if @ticket.cancel!
      redirect_to admin_tickets_path, notice: "Ticket cancelled."
    else
      redirect_to admin_tickets_path, alert: "Failed to cancel ticket."
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:item_id, :user_id, :state)
  end
end
