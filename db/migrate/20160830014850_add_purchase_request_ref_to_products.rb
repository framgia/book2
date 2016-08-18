class AddPurchaseRequestRefToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :purchase_request, index: true
  end
end
