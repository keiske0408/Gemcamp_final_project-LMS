class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.role == 'admin'
      # Admin specific logic
    else
      # Client specific logic
    end
  end
end
