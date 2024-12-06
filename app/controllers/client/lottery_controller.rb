class Client::LotteryController < ApplicationController
  before_action :authenticate_client!, only: [:buy_tickets]
  before_action :fetch_banners, only: [:index]
  before_action :fetch_news_tickers, only: [:index]

  def index
    @categories = Category.all

    @selected_category = params[:category]
    @items = Item.where(status: 1, state: 'starting')

    # Filter items by category if category parameter is present
    if params[:category].present? && params[:category] != 'All'
      @items = @items.includes(:categories).where(categories: { id: params[:category] })
    end

    # Pagination (uncomment if pagination gem is used)
    @paginated_items = @items.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
    @total_tickets = @item.tickets.count # Total tickets purchased
    @minimum_tickets = @item.minimum_tickets # Minimum tickets required
    # Ensure only items with state 'starting' are viewable
    if @item.state != 'starting'
      redirect_to client_lottery_index_path, alert: 'This item is not available.'
      return
    end

    # Show the client's own tickets for this item
    if current_client
      @user_tickets = @item.tickets.where(user: current_client)
    else
      @user_tickets = []
    end
  end

  def buy_tickets
    @item = Item.find(params[:id])
    quantity = params[:quantity].to_i

    # Check if user has enough coins
    if current_client.coins < quantity
      flash[:alert] = 'Not enough coins to buy tickets.'
      redirect_to client_lottery_path(@item)
      return
    else
      # Create tickets and deduct coins
      Ticket.transaction do
        quantity.times do
          Ticket.create!(
            item: @item,
            user: current_client,
          )
        end
      end

      flash[:notice] = "Successfully bought #{quantity} ticket(s)."
      redirect_to client_lottery_path(@item)
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

