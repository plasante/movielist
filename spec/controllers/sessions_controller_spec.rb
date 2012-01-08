require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => %(Sign in))
    end
  end

  describe "GET 'create'" do
    describe "with invalid username/password" do
      before(:each) do
        @attr = { :username => "", :password => "" }
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => %(Sign in))
      end
      
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have a flash.now[:error] message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "with valid username/password" do
      before(:each) do
        @user = Factory(:user)
        @attr = { :username => @user.username, :password => @user.password}
      end
      
      it "should sign a user in " do
        post :create, :session => @attr
        controller.should be_signed_in
        controller.current_user.should == @user
      end
      
      it "should redirect to the home page" do
        post :create, :session => @attr
        response.should redirect_to root_path
      end
    end
  end

  describe "GET 'destroy'" do
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      controller.current_user.should be_nil
      response.should redirect_to root_path
    end
  end

end
