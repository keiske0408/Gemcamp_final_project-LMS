class Client::LotteryController < ApplicationController
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
end
