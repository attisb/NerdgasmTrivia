class Backend::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  def index
    if params[:s]
      @basic_users = User.where(admin: false, host: false).where('first_name LIKE :search OR last_name LIKE :search OR email LIKE :search', search: params[:s]).paginate(:page => params[:page]).order(first_name: :asc)
    else      
      @basic_users = User.where(admin: false, host: false).paginate(:page => params[:page]).order(first_name: :asc)
    end
    @admin_users = User.where(admin: true).order(first_name: :asc)
    @host_users = User.where(host: true).order(first_name: :asc)
  end
  
  def edit
    @score = Score.where(user_id: @user.id).order(created_at: :desc).first
  end
  
  def update
    if @user.update(user_params)
      redirect_to backend_users_path, notice: 'User updated'
    else
      render :edit
    end
  end
  
  def destroy
    if user_signed_in?
      scores = Score.where(user_id: params[:id])
      scores.destroy_all
      @user.destroy
      redirect_to backend_users_path, notice: "Deleted user."
    else
      redirect_to backend_users_path, alert: "Unable to delete user."
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      if current_user.admin?
        params.require(:user).permit(:first_name, :last_name, :description, :admin, :host, :visible)
      else
        params.require(:user).permit(:first_name, :last_name, :description, :visible)
      end
    end
  
end
