class Backend::ScoresController < ApplicationController
  before_action :authenticate_admin!

  def update
    scores = params[:teams]
    
    scores.each do |team, update_score|
      players = Score.where(team_id: team, event_id: params[:event])
      players.each do |player|
        player.points += update_score[0].to_i
        player.save
      end
    end
    
    update_scores_by_internal
    
    redirect_to backend_event_path(params[:id]), notice: 'Updated scores'
  end

  def adjust_score
    score = Score.find(params[:score])
    unless score.blank?
      score.points = params[:new_point]
      score.save
    end
    
    update_scores_by_internal
    
    redirect_to edit_backend_user_path(params[:user]), notice: 'Updated score for player.'
  end
  
end
