class AddScoreToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :score, :integer
  end
end
