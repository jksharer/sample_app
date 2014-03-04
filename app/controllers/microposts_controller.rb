class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created."
      redirect_to root_path
    else
      # flash[:error] = "invalid input for micropost."  使用对象Object内置的错误提示 
      # @feed_items = []
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end
  
  private 
    def micropost_params
      params.require(:micropost).permit(:content)
    end
    
    def correct_user
      #这里，我们使用的是 find_by，而没用 find，因为如果没有找到微博 find 会抛出异常，而不会返回 nil。
      @micropost = current_user.microposts.find_by(id: params[:id]) 
      redirect_to root_path if @micropost.nil?
    end  
end