class Admin::WinnersController < Admin::BaseController
  before_action :set_winner, except: [:index]

  def index
    @q = params[:q]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @state = params[:state]

    @winners = Winner.all.order(created_at: :desc).page(params[:page]).per(10)

    @winners = @winners.where("serial_number LIKE ?", "%#{@q}%") if @q.present?
    @winners = @winners.joins(:user).where("users.email LIKE ?", "%#{@q}%") if @q.present?
    @winners = @winners.where(state: @state) if @state.present?
    if @start_date.present? && @end_date.present?
      @winners = @winners.where(created_at: @start_date..@end_date)
    end


    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << ['Serial Number', 'Email', 'State', 'Price', 'Created At']

          Winner.all.each do |winner|
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
    redirect_to admin_winners_path(page: params[:page]), notice: "Winner submitted successfully."
  end

  def pay
    @winner.pay!
    redirect_to admin_winners_path(page: params[:page]), notice: "Winner marked as paid."
  end

  def ship
    @winner.ship!
    redirect_to admin_winners_path(page: params[:page]), notice: "Winner marked as shipped."
  end

  def deliver
    @winner.deliver!
    redirect_to admin_winners_path(page: params[:page]), notice: "Winner marked as delivered."
  end

  def publish

    if @winner.publish!

      Order.create!(
        user_id: @winner.user_id,
        genre: :share,
        coin: 10,
        state: :paid,
        amount: 100,
        remarks: "Thank you for your feedback!"
      )
      redirect_to admin_winners_path(page: params[:page]), notice: "Winner published successfully, and bonus coins awarded."
    else
      redirect_to admin_winners_path(page: params[:page]), alert: "An error occurred: #{e.message}"
    end
  end

  def remove_publish
    @winner.remove_publish!
    redirect_to admin_winners_path(page: params[:page]), notice: "Publication removed successfully."
  end

  def re_publish
    @winner.re_publish!
    redirect_to admin_winners_path(page: params[:page]), notice: "Publication published successfully."
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end
