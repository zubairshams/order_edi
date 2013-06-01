class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.integer :user_id
      t.string :item_name
      t.float :price
      t.string :description
      t.string :billing_address
      t.string :status, :default => 'pending'

      t.timestamps
    end
  end
end
