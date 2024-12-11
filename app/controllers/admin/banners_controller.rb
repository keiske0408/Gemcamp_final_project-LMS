class Admin::BannersController < Admin::BaseController
  before_action :set_banner, only: %i[edit update destroy]

  def index
    @banners = Banner.order(:sort).page(params[:page])
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to admin_banners_path, notice: 'Banner was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      redirect_to admin_banners_path, notice: 'Banner was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_path, notice: 'Banner was successfully deleted.'
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status,:sort)
  end
end
