class Order < ActiveRecord::Base
  audited
  attr_accessible :billing_address, :customer_name, :description, :item_name, :price, :user_id
  validates :billing_address, :customer_name, :description, :item_name, :price, presence: true
end
