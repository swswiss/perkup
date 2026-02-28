class AddNameToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :name, :string
  end
end
