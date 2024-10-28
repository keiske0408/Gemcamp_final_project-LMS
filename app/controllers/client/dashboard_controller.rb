module Client
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      # Client-specific logic can go here
    end
  end
end
