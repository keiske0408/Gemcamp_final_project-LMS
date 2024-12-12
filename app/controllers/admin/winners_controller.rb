class Admin::WinnersController < Admin::BaseController
  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @q = params[:q]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @state = params[:state]

    # Base query
    @winners = Winner.all

    # Apply filters
    @winners = @winners.where("serial_number LIKE ?", "%#{@q}%") if @q.present?
    @winners = @winners.joins(:user).where("users.email LIKE ?", "%#{@q}%") if @q.present?
    @winners = @winners.where(state: @state) if @state.present?
    if @start_date.present? && @end_date.present?
      @winners = @winners.where(created_at: @start_date..@end_date)
    end

    @winners = @winners.order(created_at: :desc).page(params[:page]) # Add pagination if needed

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << ['Serial Number', 'Email', 'State', 'Price', 'Created At']

          @winners.find_each do |winner|
            csv << [
              winner.ticket.serial_number,
              winner.user.email,
              winner.state.humanize,
              winner.price,
              winner.created_at.strftime('%Y-%m-%d %H:%M:%S')
            ]
          end
        end

        send_data csv_string, filename: "winners_#{Time.now.to_i}.csv", type: 'text/csv'
      end
    end
  end

  def submit
    @winner.submit!
    redirect_to admin_winners_path, notice: "Winner submitted successfully."
  end

  def pay
    @winner.pay!
    redirect_to admin_winners_path, notice: "Winner marked as paid."
  end

  def ship
    @winner.ship!
    redirect_to admin_winners_path, notice: "Winner marked as shipped."
  end

  def deliver
    @winner.deliver!
    redirect_to admin_winners_path, notice: "Winner marked as delivered."
  end

  def publish
    @winner.publish!
    redirect_to admin_winners_path, notice: "Winner published successfully."
  end

  def remove_publish
    @winner.remove_publish!
    redirect_to admin_winners_path, notice: "Publication removed successfully."
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end
