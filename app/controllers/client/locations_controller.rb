class Client::LocationsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_location, only: [:show, :edit, :update, :destroy, :details]

  def index
    @locations = current_client.locations.order(is_default: :desc, created_at: :asc)
  end

  def show
  end

  def new
    @location = current_client.locations.build
  end

  def create
    @location = current_client.locations.build(location_params)
    if current_client.locations.count >= 5
      flash[:alert] = "You can only have up to 5 addresses."
      render :new
    elsif @location.save
      flash[:notice] = "Address successfully created."
      redirect_to client_location_path(@location)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      flash[:notice] = "Address successfully updated."
      redirect_to client_location_path(@location)
    else
      render :edit
    end
  end

  def destroy
    if @location.is_default? && current_client.locations.count > 1
      next_default = current_client.locations.where.not(id: @location.id).first
      if next_default
        next_default.update!(is_default: true)
      end
    elsif @location.is_default?
      flash[:alert] = "You must have at least one default address."
      redirect_to client_locations_path and return
    end

    if @location.destroy
      flash[:notice] = "Address successfully deleted."
    else
      flash[:alert] = "Address could not be deleted."
    end
    redirect_to client_locations_path
  end

  def details
    render partial: "client/locations/details", locals: { location: @location }
  end


  private

  def set_location
    @location = current_client.locations.find(params[:id] || params[:location_id])
  end

  def location_params
    params.require(:location).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id)
  end
end
