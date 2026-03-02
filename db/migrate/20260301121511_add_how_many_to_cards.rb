class AddHowManyToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :how_many, :integer, null: false, default: 1
  end
end
