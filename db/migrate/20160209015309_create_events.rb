class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :code
      t.datetime :date_start
      t.datetime :date_end
      t.integer :bonus
      t.boolean :visible
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
