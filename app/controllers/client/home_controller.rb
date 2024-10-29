class Client::HomeController < ApplicationController
  before_action :authenticate_client! # Ensure user is authenticated
  def index
    redirect_to root_path, alert: 'Access denied!' unless current_user.client?
    # Assuming you have a method to check roles
  end

  def new
    render template: 'client/home'
  end



end

