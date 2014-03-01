class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase )
    # user = User.find_by_email(params[:session][:email].downcase )
    # user = User.last
    if user && user.authenticate(params[:session][:password])
      sign_in user
      # redirect_to user_path(user)
      redirect_back_or user  
    else 
      flash.now[:error] = "Invalid email/password combination, #{params[:session][:email].downcase},
        user.nil?---#{@user.nil?} }"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
