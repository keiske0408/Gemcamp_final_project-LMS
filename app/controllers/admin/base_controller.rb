class Admin::BaseController < AdminsController
  before_action :global_search

  layout 'admin'

  private
  def global_search
    return unless params[:q].present?

    query = params[:q].to_s.downcase.strip

    paths = {
      "member Levels" => admin_member_levels_path,
      "user invite list" => invite_list_admin_users_path,
      "user list" => user_list_admin_users_path,
      "item list" => admin_items_path,
      "item category list" => admin_categories_path,
      "orders" => admin_orders_path,
      "tickets" => admin_tickets_path,
      "winners" => admin_winners_path,
      "offers" => admin_offers_path,
      "news ticker" => admin_news_tickers_path,
      "banner" => admin_banners_path
    }

    path = paths.find { |key, _| key.include?(query) }&.last

    if path
      redirect_to path and return
    else
      flash[:alert] = "No match found for '#{query}'."
      redirect_to request.referrer || admin_users_path and return
    end
  end
end
