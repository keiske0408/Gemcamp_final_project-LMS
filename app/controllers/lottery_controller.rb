class LotteryController < ApplicationController
  def index
    # Fetch categories and their items that are online, active, and in 'starting' state
    @categories = Category.includes(:items)
                          .where(items: { status: 'active', state: 'starting' })
  end
end
