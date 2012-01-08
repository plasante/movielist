class SessionsController < ApplicationController
  def new
    @title = %(Sign in)
  end

  def create
    user = User.authenticate(params[:session][:username],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = %(Invalid username/password combination)
      @title = %(Sign in)
      render :new
    else
      sign_in user
      redirect_back_or root_path
    end
  end

  def destroy
    signout
    redirect_to root_path
  end
end
