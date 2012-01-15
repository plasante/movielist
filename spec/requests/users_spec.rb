require 'spec_helper'

describe "Users" do
  describe "signin/signout" do
    describe "invalid signin" do
      it "should re-render the login page" do
        visit signin_path
        fill_in :session_username, :with => ""
        fill_in :session_password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => %(Invalid))
        response.should render_template('sessions/new')
      end
    end
    
    describe "valid signin/signout" do
      it "should sign a user in and out" do
        @user = Factory(:user)
        visit signin_path
        fill_in :session_username, :with => @user.username
        fill_in :session_password, :with => @user.password
        click_button
        controller.should be_signed_in
        click_link 'Sign out'
        controller.should_not be_signed_in
      end
    end
  end # of describe signin/signout
  
  describe "signup" do
    describe "signup failure" do
      it "should not create a user" do
        lambda do
          visit signup_path
          fill_in :user_first_name, :with => ""
          fill_in :user_last_name,  :with => ""
          fill_in :user_username,   :with => ""
          fill_in :user_email,      :with => ""
          fill_in :user_password,   :with => ""
          fill_in :user_password_confirmation, :with => ""
          click_button
        end.should_not change(User, :count)
        controller.should_not be_signed_in
      end
    end
    
    describe "signup success" do
      it "should create a user" do
        lambda do
          visit signup_path
          fill_in :user_first_name, :with => "Pierre"
          fill_in :user_last_name,  :with => "Lasante"
          fill_in :user_username,   :with => "plasante"
          fill_in :user_email,      :with => "plasante@email.com"
          fill_in :user_password,   :with => "123456"
          fill_in :user_password_confirmation, :with => "123456"
          click_button
        end.should change(User, :count).by(1)
        controller.should be_signed_in
        response.should render_template("users/show")
        response.should have_selector("div.flash.notice", :content => "Welcome")
      end
    end
  end
end
