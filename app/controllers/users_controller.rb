class UsersController < ApplicationController
  # require 'sessions_helper'
  include SessionsHelper
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@user)  
    else 
      render 'new'
    end
  end
  
  def edit
    # @user = User.find(params[:id])
  end
  
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'  
    end
  end
  
  def index
    #User.paginate方法根据 :page 的值，一次取回一系列的用户（默认为 30 个）,
    #如果指定的页数不存在，paginate 会显示第一页。
    @users = User.paginate(page: params[:page]) 
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # def signed_in_user
      # store_location  #存储登陆前尝试访问的地址
      # redirect_to signin_path, notice: "Please sign in." unless sign_in?
    # end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)   
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
