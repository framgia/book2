class RemoveUniqueFromEmail < ActiveRecord::Migration
  def change
  	remove_column :users, :email, unique: true
  	add_index :users, :email, default: "sample@framgia.com"
  end
end
