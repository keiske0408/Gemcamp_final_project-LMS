class Admin::UsersController < Admin::BaseController
  def index
    @client_users = User.includes(:children, :parent).page(params[:page]).per(15)
  end
end


