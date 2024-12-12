class Admin::UsersController < Admin::BaseController
  require 'csv'

  def index
    @client_users = User.includes(:children, :parent).page(params[:page]).per(15)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            'Parent Email', 'Email', 'Total Deposit', 'Member Total Deposits',
            'Coins', 'Total Used Coins', 'Children Members', 'Phone Number', 'Level'
          ]

          @client_users.each do |user|
            csv << [
              user.parent&.email,
              user.email,
              user.total_deposit || 0,
              user.children.pluck(:total_deposit).reject(&:nil?).sum,
              user.coins || 0,
              0,
              user.children_members,
              user.phone_number || "N/A",
              user.member_level&.level,
            ]
          end
        end

        render plain: csv_string
      }
    end
  end

  def invite_list
    @invited_user = User.where.not(parent_id: nil) # Only fetch users with a parent

    if params[:parent_email_cont].present?
      @invited_user = @invited_user.joins(:parent).where('parents_users.email LIKE ?', "%#{params[:parent_email_cont]}%")
    end

    @users = @invited_user.includes(:parent).order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << [
            'Parent Email', 'Email', 'Total Deposit', "Members' Total Deposit",
            'Coins', 'Created At', 'Coins Used Count', 'Child Members'
          ]

          @users.each do |user|
            csv << [
              user.parent&.email || "N/A",
              user.email,
              user.total_deposit || 0,
              user.children.pluck(:total_deposit).reject(&:nil?).sum,
              user.coins || 0,
              user.created_at.strftime("%Y-%m-%d %H:%M:%S"),
              user.coins_used_count,
              user.children.count
            ]
          end
        end

        render plain: csv_string
      end
    end
  end
end


