class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.boolean :visible
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
