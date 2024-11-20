class Client::LotteryController < ApplicationController
  before_action :authenticate_client!, only: [:buy_tickets]
  def index
    @categories = Category.all
    Rails.logger.debug "Categories: #{@categories.inspect}"

    @selected_category = params[:category]
    @items = Item.where(status: 1, state: 'starting')

    # Filter items by category if category parameter is present
    if params[:category].present? && params[:category] != 'All'
      @items = @items.includes(:categories).where(categories: { id: params[:category] })
    end

    # Pagination (uncomment if pagination gem is used)
    @paginated_items = @items.page(params[:page]).per(3)
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
        redirect_to client_lottery_path(@item), alert: 'Not enough coins to buy tickets.'
        return
      end

      # Create tickets and deduct coins
      Ticket.transaction do
        quantity.times do
          Ticket.create!(
            item: @item,
            user: current_client,
            state: 'pending',
            serial_number: generate_serial_number(@item),
            batch_count: @item.batch_count,
            coins: 1
          )
        end

        current_client.update!(coins: current_client.coins - quantity)
      end

      redirect_to client_lottery_path(@item), notice: "Successfully bought #{quantity} ticket(s)."
    end

    private

    def generate_serial_number(item)
      "#{item.id}-#{SecureRandom.hex(4)}"
    end
  end

