class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: %i[show edit update destroy restore]

  def index
    @categories = Category.order(:sort).page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
    else
      redirect_to admin_categories_path, alert: @category.errors.full_messages.to_sentence
    end
  end

  def restore
    if @category.restore
      redirect_to admin_categories_path, notice: 'Category was successfully restored.'
    else
      redirect_to admin_categories_path, alert: 'Failed to restore category.'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name,:sort)
  end
end
