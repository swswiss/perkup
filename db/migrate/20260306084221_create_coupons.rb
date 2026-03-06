class CreateCoupons < ActiveRecord::Migration[7.2]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.references :user, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true
      t.boolean :used, default: false
      t.datetime :used_at
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
