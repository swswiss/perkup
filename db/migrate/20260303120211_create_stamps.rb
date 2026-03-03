class CreateStamps < ActiveRecord::Migration[7.2]
  def change
    create_table :stamps do |t|
      t.references :user_card, null: false, foreign_key: true
      t.string :scan_token, null: false

      t.timestamps
    end

    add_index :stamps, :scan_token, unique: true
  end
end
