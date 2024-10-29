class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_admin

  def index
  end

  def check_admin
    puts current_admin.inspect # Debug line
    unless current_admin&.admin?
      redirect_to new_admin_session_path, alert: 'Access denied!'
    end
  end

end

