class Backend::TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  def index
    if params[:s]
      #@teams = Team.where('name LIKE :search', search: params[:s]).joins(:scores).paginate(:page => params[:page]).select("teams.*, SUM(scores.points) as points").group("teams.id").order('points desc')
      @teams = Team.where('name LIKE :search', search: params[:s]).paginate(:page => params[:page]).order(score: :desc)
    else
      #@teams = Team.joins(:scores).paginate(:page => params[:page]).select("teams.*, SUM(scores.points) as points").group("teams.id").order('points desc')
      @teams = Team.where(visible: true).paginate(:page => params[:page]).order(score: :desc)
    end
    if @teams.empty?
      @teams = Team.where(visible: true).paginate(:page => params[:page]).order(score: :desc)
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

  def destroy
    scores = Score.where(team_id: @team.id)
    scores.destroy_all
    @team.destroy
    redirect_to teams_path, notice: "Yay! The team was deleted from the system."
  end


  def update_scores
    teams = Team.all
    teams.each do |team|
      team.update_attribute(:score, team.sum_score)
    end
    redirect_to backend_teams_path, notice: 'Updated scores.'
  end

    
  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
        params.require(:team).permit(:name, :description, :visible)
    end
  
end
