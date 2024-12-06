class Client::ShopController < ApplicationController
  before_action :authenticate_client!, only: [:show, :purchase]
  before_action :fetch_banners, only: [:index]
  before_action :fetch_news_tickers, only: [:index]
  def show
    @offer = Offer.find(params[:id])
  end

  def index
    @offers = Offer.active.page(params[:page])
    # Offers are loaded via load_offers
  end

  def purchase
    if client_signed_in?
      offer = Offer.find(params[:id])
      order = current_client.orders.build(
        offer: offer,
        amount: offer.amount,
        coin: offer.coin,
        genre: :deposit, # Assuming the genre for offers is "deposit"
        state: :pending
      )

      if order.save
        order.submit!
        order.update(serial_number: order.generate_serial_number)
        redirect_to client_shop_index_path, notice: "Offer purchased successfully!"
      else
        redirect_to shop_path, alert: "Failed to purchase offer. Please try again."
      end
    else
      redirect_to new_client_session_path, alert: "You must be signed in to purchase an offer."
    end
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
