class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :price, :integer
    add_column :products, :purchase_date, :date
  end
end
