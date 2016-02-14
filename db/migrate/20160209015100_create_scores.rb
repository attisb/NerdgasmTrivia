class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :event_id
      t.integer :team_id
      t.integer :user_id
      t.integer :points

      t.timestamps null: false
    end
  end
end
