class Admin::UsersController < Admin::BaseController
  def index
    @client_users = User.includes(:children, :parent).page(params[:page]).per(15)
  end

  def invite_list
    @invited_user = User.where.not(parent_id: nil) # Only fetch users with a parent

    if params[:parent_email_cont].present?
      @invited_user = @invited_user.joins(:parent).where('parents_users.email LIKE ?', "%#{params[:parent_email_cont]}%")
    end

    @users = @invited_user.includes(:parent).order(created_at: :desc).page(params[:page])
  end

end


