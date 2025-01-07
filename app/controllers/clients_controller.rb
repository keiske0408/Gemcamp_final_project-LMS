class ClientsController < ApplicationController
  # before_action :authenticate_client!
  before_action :authorize_client

  private

  def authorize_client
    if current_user&.admin?
      sign_out(current_admin)
      redirect_to new_client_session_path, alert: 'Invalid Email or password'
    end
  end

  def current_user
    warden.authenticate(scope: :client)
  end
end