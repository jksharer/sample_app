module SessionsHelper
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def current_user?(user)
    user == @current_user
  end
  
  def sign_in?
    !current_user.nil?
  end
  
  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to (session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location   #在session中存储尝试访问的地址
    session[:return_to] = request.fullpath if request.get?      
  end
  
  def signed_in_user
      store_location  #存储登陆前尝试访问的地址
      redirect_to signin_path, notice: "Please sign in." unless sign_in?
  end
   
end
