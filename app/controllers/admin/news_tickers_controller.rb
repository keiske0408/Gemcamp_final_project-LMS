class Admin::NewsTickersController < Admin::BaseController
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.order(:sort).page(params[:page])
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)

    if @news_ticker.save
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    redirect_to admin_news_tickers_path, notice: 'News ticker was successfully deleted.'
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status,:sort)
  end
end
