class Client::LocationsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = current_client.locations
  end

  def show
  end

  def new
    @location = current_client.locations.build
  end

  def create
    @location = current_client.locations.build(location_params)

    Rails.logger.debug "Location Params: #{location_params.inspect}"

    if current_client.locations.count >= 5
      flash[:alert] = "You can only have up to 5 addresses."
      render :new
    elsif @location.save
      flash[:notice] = "Address successfully created."
      redirect_to client_location_path(@location)
    else
      Rails.logger.error @location.errors.full_messages
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
    @location.destroy
    flash[:notice] = "Address successfully deleted."
    redirect_to client_locations_path
  end

  private

  def set_location
    @location = current_client.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id)
  end
end
