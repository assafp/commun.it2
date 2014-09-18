class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

  def current_user
    @current_user ||= (User.find_by_id(cookies[:user_id]) if (cookies[:user_id] && !cookies[:user_id].empty?)) 
  end
end
