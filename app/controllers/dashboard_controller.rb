class DashboardController < ApplicationController

  before_filter :check_current_user, except: :main

  def main
    if current_user
      current_user.update_follows 
      @new_followers = current_user.new_followers(cookies[:first_login] == 'true')
      @new_unfollowers = current_user.new_unfollowers
      member_ids = (@new_followers + @new_unfollowers).map{|member| member.attrs[:id]}
      @mentioners_ids = current_user.mentions(member_ids)
    end
  end

  def dismiss
    dismiss_and_redirect(params[:id])
  end

  def follow
    current_user.twitter_client.follow(params[:id])
    dismiss_and_redirect(params[:id])
  end
  
  def unfollow
    current_user.twitter_client.unfollow(params[:id])
    dismiss_and_redirect(params[:id])
  end
  
  def say_hi
    current_user.twitter_client.update("Hi @#{params[:screen_name]} how are you today?")
    dismiss_and_redirect(params[:id])
  end

  private

  def dismiss_and_redirect(id)
    Follow.update_all({dismissed_on: Time.now}, {user_id: current_user.id, follower_uid: id})
    redirect_to action: :main
  end

  def check_current_user
    redirect_to root_url unless current_user
  end

end
