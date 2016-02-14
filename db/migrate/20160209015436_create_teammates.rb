class CreateTeammates < ActiveRecord::Migration
  def change
    create_table :teammates do |t|
      t.integer :user_id
      t.integer :team_id

      t.timestamps null: false
    end
  end
end
