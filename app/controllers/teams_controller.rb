class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_access!, only: [:edit, :update]
  

  def index
    @teams = Team.where(visible: true).paginate(:page => params[:page]).joins(:scores).paginate(:page => params[:page]).select("teams.*, SUM(scores.points) as points").group("teams.id").order('points desc')
    #@teams = Team.where(visible: true).paginate(:page => params[:page]).joins(:scores).group('scores.team_id').order('scores.points desc')
    if @teams.empty?
      @teams = Team.where(visible: true).paginate(:page => params[:page])
    end
  end
  
  def new
    if current_user.teams.count >= ApplicationController::USER_MAX_CREATE_TEAMS
      redirect_to teams_path, alert: "Sorry you've hit the limit on the number of teams you can create."
    else
      @team = Team.new
    end
  end
  
  def create
    @team = Team.new(team_params)
    @team.user_id = current_user.id
    if current_user.teams.count >= ApplicationController::USER_MAX_CREATE_TEAMS
      redirect_to teams_path, alert: "Sorry you've hit the limit on the number of teams you can create."
    else
      if @team.save
        Teammate.create(user_id: current_user.id, team_id: @team.id)
        redirect_to teams_path, notice: "Woot woot! You've made a team."
      else
        render :new
      end
    end
  end
  
  def edit
  end
  
  def update
    if @team.update(team_params)
      redirect_to teams_path, notice: 'Great your team info has been updated.'
    else
      render :edit
    end
  end
  
  def destroy
    if user_signed_in? && @team.user == current_user
      scores = Score.where(team_id: @team.id)
      scores.destroy_all
      @team.destroy
      redirect_to teams_path, notice: "Yay! The team was deleted from the system."
    else
      redirect_to teams_path, alert: "Oh no! We were unable to delete the team."
    end
  end

  def join
    @team = Team.find_by(code: params[:code])
    if @team.nil?
      redirect_to edit_user_registration_path, alert: 'We\'re sorry we can\'t find that team.'
    else
      if @team.users.count >= ApplicationController::TEAM_MAX_MEMBERS
        redirect_to edit_user_registration_path, alert: 'Sorry this team already has the max amount of players.'
      else
        Teammate.find_or_create_by(user_id: current_user.id, team_id: @team.id)
        redirect_to edit_user_registration_path, notice: 'Awesomesauce! You\'ve joined the team.'
      end
    end
  end
  
  def leave
    team = Team.find(params[:id])
    if team.nil?
      redirect_to teams_path, alert: 'We\'re sorry we can\'t find that team'
    else
      scores = Score.where(team_id: team.id)
      teammates = Teammate.find_by(team_id: team.id, user_id: current_user.id)
      scores.destroy_all
      teammates.destroy unless teammates.nil?
      redirect_to teams_path, notice: 'Great? You have successfully left the team.'
    end
  end






  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :description)
    end
    
    def authenticate_access!
      if authenticate_user! && current_user == @team.user
        true
      else
        redirect_to teams_path, alert: 'No access'
      end
    end
end
