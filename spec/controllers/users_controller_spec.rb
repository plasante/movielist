require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET :new" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => %(Sign up))
    end
    
    it "should have a @user instance variable" do
      get :new
      assigns(:user).should_not be_blank
    end
  end # of describe GET :new
  
  describe "GET :show" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should have the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => %(Show user))
    end
    
    describe "invalid user" do
      it "should have a flash error message" do
        get :show, :id => 0
        flash[:error].should =~ /Invalid/i
      end
      
      it "should redirect to the home page" do
        get :show, :id => 0
        response.should redirect_to root_path
      end
    end # of describe invalid user
  end # of describe GET :show
  
  describe "POST :create" do
    describe "failure" do
      before(:each) do
        @attr = {:first_name => "",
                 :last_name  => "",
                 :username   => "",
                 :email      => "",
                 :password   => "",
                 :password_confirmation => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => %(Sign up))
      end
      
      it "should re-render the new page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = {:first_name => "Pierre",
                 :last_name  => "Lasante",
                 :username   => "plasante",
                 :email      => "plasante@email.com",
                 :password   => "123456",
                 :password_confirmation => "123456"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to user_path(assigns(:user))
      end
      
      it "should have a welcome flash message" do
        post :create, :user => @attr
        flash[:notice].should =~ /Welcome/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end # of describe success
    
    describe "USERS_MAX_COUNT has been reached" do
      before(:each) do
        USERS_MAX_COUNT.times do |n|
          Factory(:user, :email => Factory.next(:email), :username => Factory.next(:username))
        end
        @attr = {:first_name => "Pierre",
                 :last_name  => "Lasante",
                 :username   => "plasante",
                 :email      => "plasante@email.com",
                 :password   => "123456",
                 :password_confirmation => "123456"}
      end
      
      it "should have a flash[:error] message" do
        post :create, :user => @attr
        flash[:error].should =~ /Maximum/i
      end
    end # of USERS_MAX_COUNT has been reached
  end # of POST :create
end
