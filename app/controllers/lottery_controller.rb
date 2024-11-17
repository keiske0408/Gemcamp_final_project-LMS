class LotteryController < ApplicationController
  def index
    @categories = Category.all
    @selected_category = params[:category]

    if @selected_category.present? && @selected_category != 'All'
      # Adjust the query for many-to-many relationship
      filtered_items = Item.joins(:categories)
                           .where(status: 'active', state: 'starting')
                           .where(categories: { name: @selected_category })
    else
      filtered_items = Item.where(status: 'active', state: 'starting')
    end

    # Debugging output to check if items are being found
    Rails.logger.debug "Filtered items: #{filtered_items.inspect}"

    @paginated_items = filtered_items.page(params[:page]).per(5)
  end

end
