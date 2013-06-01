require 'rubygems'
require 'rufus/scheduler'

class Order::Schedular
  
  def self.process(order)
    scheduler = Rufus::Scheduler.start_new

    scheduler.in '1m' do
      order.status = Order::STATUS[:completed]
      order.save
      OrderMailer.order_completed(order).deliver
    end
  end
end
