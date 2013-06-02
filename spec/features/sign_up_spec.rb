require 'spec_helper'

feature "Signup process", :js => true do
  
  scenario 'with valid email and password' do
    sign_up_with 'test@test.com', 'test1234'
    expect(page).to have_content("Welcome to home page")
  end

  scenario 'with invalid email' do
    sign_up_with 'test@at', 'test1234'
    expect(page).to have_content('Email is invalid')
  end

  private
  
  def sign_up_with(email, password)
    visit new_user_registration_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Sign up'
  end
end
