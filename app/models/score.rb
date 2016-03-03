class Score < ActiveRecord::Base
  belongs_to :event
  belongs_to :team
  belongs_to :user
  scope :team_count, -> { distinct.count(:team_id) }
  scope :player_count, -> { distinct.count(:user_id) }
  scope :current_score, -> { order(points: :desc).first.points } #sum(:points)
end
