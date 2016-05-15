class CreatePurchaseRequests < ActiveRecord::Migration
  def change
    create_table :purchase_requests do |t|
      t.references :m_book
      t.references :user
      t.integer :state, default: 0, null: false

      t.timestamps null: false
    end
  end
end
