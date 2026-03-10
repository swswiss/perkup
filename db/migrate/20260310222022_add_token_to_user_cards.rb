class AddTokenToUserCards < ActiveRecord::Migration[7.2]
  def change
    add_column :user_cards, :token, :string
    add_index :user_cards, :token, unique: true
  end
end
