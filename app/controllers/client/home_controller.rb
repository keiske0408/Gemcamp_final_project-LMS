class Client::HomeController < ClientsController
  before_action :fetch_banners, only: [:new]
  before_action :fetch_news_tickers, only: [:new]
  # before_action :authenticate_client! # Ensure user is authenticated
  def index
  end

  def new
    render template: 'client/home'
  end

  private

  def fetch_banners
    @banners = Banner.where(status: 'active')
                     .where('online_at >= ? AND ? < offline_at', Time.current, Time.current)
  end

  def fetch_news_tickers
    @news_tickers = NewsTicker.where(status: 'active').limit(5)
  end
end


