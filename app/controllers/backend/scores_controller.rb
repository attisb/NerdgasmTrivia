class Backend::ScoresController < ApplicationController
  before_action :authenticate_admin!

  def update
    scores = params[:teams]
    
    scores.each do |team, update_score|
      players = Score.where(team_id: team)
      players.each do |player|
        player.points += update_score[0].to_i
        player.save
      end
    end
    
    redirect_to backend_event_path(params[:id]), notice: 'Updated scores'
  end
  
end
