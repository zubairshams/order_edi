class Order < ActiveRecord::Base
  audited
  attr_accessible :billing_address, :customer_name, :description, :item_name, :price, :user_id
  belongs_to :user
  validates :billing_address, :customer_name, :description, :item_name, :price, presence: true
  
  STATUS = {pending: 'pending', completed: 'completed'}
end
