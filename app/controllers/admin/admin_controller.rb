class Admin::AdminController < BaseController
  before_action :authenticate_admin!

  def index
  end

end

