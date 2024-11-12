class Admin::HomeController < Admin::BaseController
  # before_action :authenticate_admin!
  # before_action :redirect_non_admins, only: [:index]

  def index
    @client_users = User
                      .where(role: 'client')
                      .left_joins(:children_members)
                      .select(
                        'users.*',
                        'parents.email AS parent_email',
                        'COALESCE(SUM(children_members_users.total_deposit), 0) AS member_total_deposits'
                      )
                      .joins('LEFT JOIN users AS parents ON users.parent_id = parents.id')
                      .group('users.id, parents.email')
    # Admin-specific logic here
    #
  end

  private
  # def redirect_non_admins
  #   redirect_to root_path, alert: 'Access denied!' unless current_user&.role == 'admin'
  # end
end
