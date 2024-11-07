class Client::HomeController < ClientsController
  # before_action :authenticate_client! # Ensure user is authenticated
  def index
  end

  def new
    render template: 'client/home'
  end

end


