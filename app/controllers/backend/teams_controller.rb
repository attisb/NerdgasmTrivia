class Backend::TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  def index
    if params[:s]
      @teams = Team.where('name LIKE :search', search: params[:s]).joins(:scores).paginate(:page => params[:page]).order('scores.points desc')
      #@teams = Team.where('first_name LIKE :search', search: params[:s]).joins(:scores).paginate(:page => params[:page]).group('scores.team_id').order('scores.points desc')
    else
      @teams = Team.all.joins(:scores).paginate(:page => params[:page]).uniq('scores.team_id').order('scores.points desc')
      #@teams = Team.all.joins(:scores).paginate(:page => params[:page]).group('scores.team_id').order('scores.points desc')
    end
    if @teams.empty?
      @teams = Team.where(visible: true).paginate(:page => params[:page])
    end
  end
  
  def edit
  end
  
  def update
    if @team.update(team_params)
      redirect_to backend_teams_path, notice: 'Team updated'
    else
      render :edit
    end
  end
    
  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
        params.require(:team).permit(:name, :description, :visible)
    end
  
end
