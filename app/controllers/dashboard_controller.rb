class DashboardController < ApplicationController

  def main
    if current_user
      current_user.update_follows 
      @new_followers = current_user.new_followers(cookies[:first_login] == 'true')
      @new_unfollowers = current_user.new_unfollowers
    end
  end

end
