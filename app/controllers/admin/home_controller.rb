class Admin::HomeController < Admin::BaseController
  # before_action :authenticate_admin!
  # before_action :redirect_non_admins, only: [:index]

  def index
    @client_users = User.includes(:children,:parent).all
    # Admin-specific logic here
    #
  end

  private
  # def redirect_non_admins
  #   redirect_to root_path, alert: 'Access denied!' unless current_user&.role == 'admin'
  # end
end
