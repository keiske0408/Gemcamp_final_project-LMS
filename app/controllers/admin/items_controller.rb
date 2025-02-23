class Admin::ItemsController < Admin::BaseController
  before_action :set_item, only: [:show, :destroy, :edit, :update, :start, :pause, :end, :cancel]
  require 'csv'

  def start
    if @item.start!
      flash[:notice] = 'Item started successfully.'
    else
      flash[:alert] = 'Unable to start the item.'
    end
    redirect_to admin_items_path(page: params[:page])
  end

  def pause
    if @item.pause!
      flash[:notice] = 'Item paused successfully.'
    else
      flash[:alert] = 'Unable to pause the item.'
    end
    redirect_to admin_items_path(page: params[:page])
  end

  def end
    if @item.end!
      flash[:notice] = 'Item ended successfully.'
    else
      flash[:alert] = 'Unable to end the item.'
    end
    redirect_to admin_items_path(page: params[:page])
  end

  def cancel
    if @item.cancel!
      flash[:notice] = 'Item cancelled successfully.'
    else
      flash[:alert] = 'Unable to cancel the item.'
    end
    redirect_to admin_items_path(page: params[:page])
  end


  def index
    @items = Item.where(deleted_at: nil).order(created_at: :desc).page(params[:page]).per(5)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << [
            'Image', 'Name', 'Quantity', 'Min Tickets', 'Batch Count',
            'Status', 'State', 'Offline At', 'Online At', 'Category'
          ]
          Item.all.find_each do |item|
            csv << [
              item.image_url, # Assuming you want to include the image URL
              item.name,
              item.quantity,
              item.minimum_tickets,
              item.batch_count,
              item.status.present? ? item.status.capitalize : 'N/A',
              item.state.present? ? item.state.capitalize : 'N/A',
              item.offline_at&.strftime("%Y/%m/%d %I:%M %p"),
              item.online_at&.strftime("%Y/%m/%d %I:%M %p"),
              item.categories.map(&:name).join(", ")
            ]
          end
        end
        send_data csv_string, filename: "items_list.csv", type: 'text/csv'
      end
    end
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    puts "Params: #{params[:item]}"
    @item = Item.new(item_params)
    puts "Image: #{@item.image}"
    # Set default batch_count if it's blank

    if @item.save
      puts "Image URL: #{@item.image.url}"
      redirect_to admin_items_path, notice: 'Item was successfully created.'
    else
      puts @item.errors.full_messages # Debug line
      flash[:alert] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    # Set default batch_count if it's blank
    puts "Parameters: #{item_params.inspect}"
    if @item.update(item_params)
      redirect_to admin_items_path, notice: 'Item was successfully updated.'
    else
      puts @item.errors.full_messages
      render :edit
    end
  end

  def destroy
    puts "Destroying item #{@item.id}"  # Add this line for debugging
    @item.destroy
    flash[:notice] = 'Item was successfully deleted.'
    redirect_to admin_items_path
  end


  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :minimum_tickets, :batch_count, :online_at, :offline_at, :start_at, :status, :image, :state, category_ids: [])
  end
end
