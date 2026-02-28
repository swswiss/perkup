class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.integer :reward_rule, null: false, default: 0
      t.string :product
      t.string :description
      t.string :color
      t.string :uuid, null: false, index: { unique: true }

      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
