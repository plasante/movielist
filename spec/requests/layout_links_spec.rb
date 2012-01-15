require 'spec_helper'

describe "LayoutLinks" do
  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => %(Movies))
  end
  
  it "should have a signin page at '/signin'" do
    get '/signin'
    response.should have_selector('title', :content => %(Sign in))
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => %(Sign up))
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end
  
  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :session_username, :with => @user.username
      fill_in :session_password, :with => @user.password
      click_button
    end
    
    it "should have a signout link " do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                                         :content => "Sign out")
    end
  end
end
