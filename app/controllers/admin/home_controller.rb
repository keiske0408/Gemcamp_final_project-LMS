class Admin::HomeController < Admin::AdminController
  before_action :authenticate_admin!
  # before_action :redirect_non_admins, only: [:index]

  def index
    render template: 'admin/home'
    # Admin-specific logic here
  end

  private

  def redirect_non_admins
    redirect_to root_path, alert: 'Access denied!' unless current_user&.role == 'admin'
  end
end
