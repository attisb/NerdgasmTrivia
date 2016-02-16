class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.text :description
      t.string :badge_type
      t.integer :trigger
      t.string :bgraphic

      t.timestamps null: false
    end
  end
end
