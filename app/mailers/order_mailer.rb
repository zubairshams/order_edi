class OrderMailer < ActionMailer::Base
  default from: "zubi@example.com"

  def order_completed(order)
    @order = order
    @admin = User.where(admin: true).first
    
    mail(
      :to       => @admin.email,
      :subject  => "Order completion"
    )
  end
end
