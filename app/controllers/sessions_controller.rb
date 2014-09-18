class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    if user = User.find_by_uid(auth["uid"]) 
      cookies[:first_login] = ''
    else
      cookies[:first_login] = 'true'
      user = User.create_with_omniauth(auth)
    end
    cookies[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    cookies[:user_id] = nil
    redirect_to root_url
  end
end