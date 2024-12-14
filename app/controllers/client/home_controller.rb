class Client::HomeController < ClientsController
  before_action :fetch_banners, only: [:new]
  before_action :fetch_news_tickers, only: [:new]
  # before_action :authenticate_client! # Ensure user is authenticated
  def index
  end

  def new
    @winners_feedback =  Winner.published.order(created_at: :desc).limit(5)
    @coming_soon_items = Item.active.starting.order(created_at: :desc).limit(8)
    render template: 'client/home'
  end

  private

  def fetch_banners
    @banners = Banner.where(status: 'active')
                     .where('online_at >= ? AND ? < offline_at', Time.current, Time.current)
                     .order(:sort)
  end

  def fetch_news_tickers
    @news_tickers = NewsTicker.active.order(:sort).limit(5)
  end
end


