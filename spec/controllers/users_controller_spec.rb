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
  
  describe "GET :edit" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit")
    end
    
    it "should have the right user" do
      get :edit, :id => @user
      assigns(:user).should == @user
    end
  end # of describe GET :edit
  
  describe "PUT :update" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :first_name => "",
                  :last_name  => "",
                  :username   => "",
                  :email      => "",
                  :password   => "",
                  :password_confirmation => ""}
      end
      
      it "should render the :edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => %(Edit user))
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :first_name => "Pierrot",
                  :last_name  => "Lasante",
                  :username   => "pierrot",
                  :email      => "pierrot@email.com",
                  :password   => "123456",
                  :password_confirmation => "123456"}
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should == @attr[:first_name]
        @user.last_name.should == @attr[:last_name]
        @user.encrypted_password.should == assigns(:user).encrypted_password
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to( user_path(assigns(:user)))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:notice].should =~ /updated/i
      end
    end # of describe success    
  end # of describe PUT :update
  
  describe "DELETE :destroy" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to root_path
      end
    end
    
    describe "for an admin user" do
      before(:each) do
        @admin_user = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email), :administrator => true)
        test_sign_in(@admin_user)
      end
      
      it "should detect if user has already been deleted" do
        delete :destroy, :id => 0
        response.should redirect_to root_path
        flash[:error].should =~ /invalid/i
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the user index page" do
        delete :destroy, :id => @user
        response.should redirect_to users_path
      end
      
      it "should not destroy itself" do
        lambda do
          delete :destroy, :id => @admin_user
        end.should_not change(User, :count)
      end
    end
  end # of DELETE :destroy
  
  describe "authentication of edit/update page" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed in users" do
      it "should deny access to edit" do
        get :edit, :id => @user
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
      
      it "should deny access to update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed in users" do
      before(:each) do
        @wrong_user = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        test_sign_in(@wrong_user)
      end
      
      it "should require matching user for edit" do
        get :edit, :id => @user
        response.should redirect_to root_path
        flash[:notice].should =~ /not allowed/i
      end
    end
  end # of authentication of edit/update page
  
  describe "GET :index" do
    describe "for non signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to signin_path
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        second = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        third  = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        
        30.times do
          Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => %(All Users))
      end
      
      it "should have an element for each user" do
        get :index
        User.paginate(:page => 1).each do |user|
          response.should have_selector('li', :content => user.username)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector('div.pagination')
      end
      
      it "should have delete links for admins" do
        @user.toggle!(:administrator)
        other_user = User.all.second
        get :index
        response.should have_selector('a', :href => user_path(other_user),
                                           :content => "delete")
      end
      
      it "should not have delete links for non-admins" do
        other_user = User.all.second
        get :index
        response.should_not have_selector('a', :href => user_path(other_user),
                                               :content => "delete")
      end
    end
  end # of GET :index
end
