class Client::LotteryController < ApplicationController
  before_action :authenticate_client!, only: [:buy_tickets]
  before_action :fetch_banners, only: [:index]
  before_action :fetch_news_tickers, only: [:index]

  def index
    @categories = Category.all.order(created_at: :desc)

    @selected_category = params[:category]
    @items = Item.where(status: 1, state: 'starting')

    # Filter items by category if category parameter is present
    if params[:category].present? && params[:category] != 'All'
      @items = @items.includes(:categories).where(categories: { id: params[:category] })
    end

    # Pagination (uncomment if pagination gem is used)
    @paginated_items = @items.order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
    @item = Item.find(params[:id])
    @total_tickets = @item.tickets.where(batch_count: @item.batch_count).count # Total tickets purchased
    @minimum_tickets = @item.minimum_tickets # Minimum tickets required
    # Ensure only items with state 'starting' are viewable
    unless @item.starting? && @item.offline_at.present? && Time.current < @item.offline_at && @item.active?
      redirect_to client_lottery_index_path, alert: 'This item is not available.'
      return
    end

    # Show the client's own tickets for this item
    @user_tickets = @item.tickets.where(batch_count: @item.batch_count, user: current_client)  if current_client
  end

  def buy_tickets
    @item = Item.find(params[:id])
    quantity = params[:quantity].to_i

    # Check if user has enough coins
    if current_client.coins < quantity
      flash[:alert] = 'Not enough coins to buy tickets.'
      redirect_to client_me_path(@item)
      return
    else
      # Create tickets and deduct coins
      Ticket.transaction do
        quantity.times do
          Ticket.create!(
            item: @item,
            user: current_client,
            batch_count: @item.batch_count
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
                      .order(:sort)
  end

  def fetch_news_tickers
    @news_tickers = NewsTicker.active.order(:sort).limit(5)
  end
end

