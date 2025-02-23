class AdminsController < ActionController::Base
  before_action :authenticate_admin!
  before_action :authorize_admin
  layout 'admin'


  private

  def authorize_admin
    if current_user&.client?
      sign_out(current_client)
      redirect_to new_admin_session_path, alert: 'Invalid Email or Password'
    end
  end

  def current_user
    warden.authenticate(scope: :admin)
  end
end