class Admin::MemberLevelsController < Admin::BaseController
  before_action :set_member_level, only: [:show, :edit, :update, :destroy]

  def index
    @member_levels = MemberLevel.all
  end

  def new
    @member_level = MemberLevel.new
  end

  def create
    @member_level = MemberLevel.new(member_level_params)
    if @member_level.save
      redirect_to admin_member_levels_path, notice: 'Member level created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @member_level.update(member_level_params)
      redirect_to admin_member_levels_path, notice: 'Member level updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @member_level.destroy
    redirect_to admin_member_levels_path, notice: 'Member level deleted successfully.'
  end

  private

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end

  def member_level_params
    params.require(:member_level).permit(:level, :required_members, :coins)
  end
end
