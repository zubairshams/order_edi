require 'spec_helper'
include CapybaraTestHelpers

feature "Order" , :js => true do
  background do
    @user = Fabricate(:user)
    @order = Fabricate(:order)
    sign_in @user
  end

  context "Index", :js => true do
    scenario 'it should list all order' do
      @order.user_id = @user.id
      @order.save!
      click_on 'Orders'
      should_see_order_detail
    end
  end

  context "New Order", :js => true do

    scenario 'Valid order' do
      click_on 'New Order'
      fill_order
      click_button 'Submit'
      expect(page).to have_content('Order was successfully created.')
    end

    scenario 'Order with missing data' do
      click_on 'New Order'
      @order.customer_name = ''
      fill_order
      click_button 'Submit'
      expect(page).to have_content("Customer name can't be blank")
    end
  end

  context "Show", :js => true do
    scenario 'it should display order detail' do
      @order.user_id = @user.id
      @order.save!
      click_on 'Orders'
      click_on @order.id
      should_see_order_detail
    end
  end

  context "Destroy", :js => true do
    scenario 'it should delete order' do
      @order.user_id = @user.id
      @order.save!
      click_on 'Orders'
      click_on 'Destroy'
      page.driver.browser.switch_to.alert.accept
      # For webkit driver, use this
      # page.execute_script 'window.confirm = function () { return true }'
      expect(page).to have_no_content(@order.customer_name)
    end
  end

  private

  def should_see_order_detail
      expect(page).to have_content(@order.status)
      expect(page).to have_content(@order.customer_name)
      expect(page).to have_content(@order.item_name)
      expect(page).to have_content(@order.price)
      expect(page).to have_content(@order.billing_address)
  end
end
