class Admin::OffersController < Admin::BaseController
  before_action :set_offer, only: %i[edit update destroy]

  def index
    @offers = Offer.all
    @offers = @offers.where(status: params[:status]) if params[:status].present?
    @offers = @offers.where(name: params[:name]) if params[:name].present?
    @offers = @offers.where(genre: params[:genre]) if params[:genre].present?
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers_path, notice: 'Offer created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      redirect_to admin_offers_path, notice: 'Offer updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to admin_offers_path, notice: 'Offer deleted successfully.'
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:name, :amount, :coin, :status, :image, :genre)
  end
end
