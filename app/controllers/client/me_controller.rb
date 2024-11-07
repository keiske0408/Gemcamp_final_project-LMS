class Client::MeController < ApplicationController
  before_action :authenticate_client!

  def show
    # Display user profile information
  end

  
end
