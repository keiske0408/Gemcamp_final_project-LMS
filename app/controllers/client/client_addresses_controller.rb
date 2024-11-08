class Client::ClientAddressesController < ApplicationController
  before_action :authenticate_client!
  before_action :set_client_address, only: [:show, :edit, :update, :destroy]

  def index
    @client_addresses = current_client.client_addresses
  end

  def show
  end

  def new
    @client_address = current_client.client_addresses.build
  end

  def create
    @client_address = current_client.client_addresses.build(client_address_params)
    if current_client.client_addresses.count >= 5
      flash[:alert] = "You can only have up to 5 addresses."
      render :new
    elsif @client_address.save
      flash[:notice] = "Address successfully created."
      redirect_to @client_address
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @client_address.update(client_address_params)
      flash[:notice] = "Address successfully updated."
      redirect_to @client_address
    else
      render :edit
    end
  end

  def destroy
    @client_address.destroy
    flash[:notice] = "Address successfully deleted."
    redirect_to client_addresses_path
  end

  private

  def set_client_address
    @client_address = current_client.client_addresses.find(params[:id])
  end

  def client_address_params
    params.require(:client_address).permit(:name, :street_address, :phone_number, :remark, :is_default, :region_id, :province_id, :city_id, :barangay_id)
  end
end

