class Backend::BadgesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_badge, only: [:show, :edit, :update, :destroy]


  def index
    @badges = Badge.all.order(badge_type: :desc)
  end

  def show
  end

  def new
    if current_user.admin?
      @badge = Badge.new
    else
      redirect_to backend_badges_path
    end
  end
  
  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      redirect_to backend_badges_path, notice: "Badge created"
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @badge.update(badge_params)
      redirect_to backend_badges_path, notice: 'Badge updated'
    else
      render :edit
    end
  end
  
  def destroy
    @badge.destroy
    redirect_to backend_badges_path, notice: "Deleted badge."
  end
  
  private
    def set_badge
      @badge = Badge.find(params[:id])
    end

    def badge_params
      params.require(:badge).permit(:name, :description, :trigger, :badge_type, :bgraphic)
    end

  
end
