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
  end
end
