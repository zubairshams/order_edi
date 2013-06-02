module CapybaraTestHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button('Sign in')
  end

  def fill_order
    fill_in 'order_customer_name',    with: @order.customer_name
    fill_in 'order_item_name',        with: @order.item_name
    fill_in 'order_price',            with: @order.price
    fill_in 'order_description',      with: @order.description
    fill_in 'order_billing_address',  with: @order.billing_address
  end
end