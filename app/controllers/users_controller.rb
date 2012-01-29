class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index,:edit,:update,:destroy]
  before_filter :admin_user, :only => :destroy
  before_filter :correct_user, :only => [:edit,:update]
  
  def new
    @title = %(Sign up)
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if User.count >= USERS_MAX_COUNT
      flash[:error] = %(Maximum number of users has been reached)
      redirect_to root_path
    else
      if @user.save
        flash[:notice] = %(Welcome to the Movie List application)
        sign_in @user
        redirect_to @user
      else
        @title = %(Sign up)
        render :new
      end
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    @title = %(Edit user)
    if @user.nil?
      flash[:error] = %(Invalid user was requested)
      redirect_to root_path
    end
  end

  def update
    begin
      @user = User.find_by_id(params[:id])
      if @user.nil?
        flash[:error] = %(Invalid user was selected)
        redirect_to root_path
      else
        if @user.update_attributes(params[:user])
          flash[:notice] = %(Updated #{@user.username})
          redirect_to @user
        else
          @title = %(Edit user)
          render :edit
        end
      end
    rescue ActiveRecord::StaleObjectError
      flash[:error] = %(User was previously changed)
      redirect_to @user
    end
  end

  def index
    @users = User.paginate( :page => params[:page] )
    @title = %(All Users)
  end

  def show
    @user = User.find_by_id(params[:id])
    @title = %(Show user)
    if @user.nil?
      flash[:error] = %(Invalid user was requested)
      redirect_to root_path
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    if @user.nil?
      flash[:error] = %(Invalid user was requested)
      redirect_to root_path
    else
      @user.destroy
      redirect_to users_path
    end
  end

private

  def admin_user
    user = User.find_by_id(params[:id])
    redirect_to root_path if !current_user.administrator? || current_user?(user)
  end
  
  def correct_user
    user = User.find_by_id(params[:id])
    flash[:notice] = %(You are not allowed to edit/update this user)
    redirect_to root_path unless current_user?(user)
  end
end
