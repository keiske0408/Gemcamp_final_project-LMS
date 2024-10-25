class ClientController < ApplicationController
  before_action :authenticate_user! # Ensure user is authenticated
  def dashboard
    unless current_user.client? # Assuming you have a method to check roles
      redirect_to root_path, alert: 'Access denied!'
  end
  end
end

