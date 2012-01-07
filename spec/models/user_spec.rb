require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :first_name            => 'Pierre',
              :last_name             => 'Lasante',
              :username              => 'plasante',
              :email                 => 'plasante@email.com',
              :password              => 'password',
              :password_confirmation => 'password',
              :administrator         => false}
  end
  
  # This is a boilerplate to make sure a new user can be created.
  it "should create a user giver valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a first_name" do
    no_first_name_user = User.new(@attr.merge(:first_name => ""))
    no_first_name_user.should_not be_valid
  end
  
  it "should reject first_name that are too long" do
    long_first_name = "a" * 51
    long_first_name_user = User.new(@attr.merge(:first_name => long_first_name))
    long_first_name_user.should_not be_valid
  end
  
  it "should require a last_name" do
    no_last_name_user = User.new(@attr.merge(:last_name => ""))
    no_last_name_user.should_not be_valid
  end
  
  it "should reject last_name that are too long" do
    long_last_name = "a" * 51
    long_last_name_user = User.new(@attr.merge(:last_name => long_last_name))
    long_last_name_user.should_not be_valid
  end
  
  it "should require a username" do
    no_username_user = User.new(@attr.merge(:username => ""))
    no_username_user.should_not be_valid
  end
  
  it "should reject username that are too short" do
    short_username = "a" * 5
    short_username_user = User.new(@attr.merge(:username => short_username))
    short_username_user.should_not be_valid
  end
  
  it "should reject username that are too long" do
    long_username = "a" * 41
    long_username_user = User.new(@attr.merge(:username => long_username))
    long_username_user.should_not be_valid
  end
  
  it "should reject duplicate username" do
    User.create!(@attr)
    duplicate_username_user = User.new(@attr)
    duplicate_username_user.should_not be_valid
  end
  
  it "should reject username identical up to case" do
    upcase_username = @attr[:username].upcase
    User.create!(@attr.merge(:username => upcase_username))
    username_user = User.new(@attr)
    username_user.should_not be_valid
  end
  
  it "should accept email with valid format" do
    %w[ plasante@email.com pierre.lasante@EMAIL.com pierre-lasante@email.ca ].each do |valid_email|
      User.new(@attr.merge(:email => valid_email)).should be_valid
    end
  end
  
  it "should reject email with invalid format" do
    %w[ plasante@email pierre!lasante@email.com plasanteemail.com ].each do |invalid_email|
      User.new(@attr.merge(:email => invalid_email)).should_not be_valid
    end
  end
  
  it "should reject duplicate email" do
    User.create!(@attr)
    same_email_user = User.new(@attr)
    same_email_user.should_not be_valid
  end
  
  it "should reject email identical up to case" do
    email_upcase = @attr[:email].upcase
    User.create!(@attr.merge(:email => email_upcase))
    user = User.new(@attr)
    user.should_not be_valid
  end
  
  it "should require a password" do
    no_password_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
    no_password_user.should_not be_valid
  end
  
  it "should reject password that are too short" do
    short_password = "a" * 5
    short_password_user = User.new(@attr.merge(:password => short_password, :password_confirmation => short_password))
    short_password_user.should_not be_valid
  end
  
  it "should reject password that are too long" do
    long_password = "a" * 41
    long_password_user = User.new(@attr.merge(:password => long_password, :password_confirmation => long_password))
    long_password_user.should_not be_valid
  end
  
  describe "password encryption" do
    it "should respond to has_password?" do
      user = User.new(@attr)
      user.should respond_to('has_password?')
    end
    
    it "should encrypt the password" do
      user = User.create!(@attr)
      user.has_password?(@attr[:password]).should be_true
    end
  end
end
