class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
    cookies[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    cookies[:user_id] = nil
    redirect_to root_url
  end
end