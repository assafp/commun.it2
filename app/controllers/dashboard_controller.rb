class DashboardController < ApplicationController

  before_filter :check_current_user, except: :main

  def main
    if current_user
      current_user.update_follows 
      @new_followers = current_user.new_followers(3, first_login?)
      @new_unfollowers = current_user.new_unfollowers(3)
      member_ids = (@new_followers + @new_unfollowers).map{|member| member.attrs[:id]}
      @mentioners_ids = current_user.mentions(member_ids)
    end
  end

  def dismiss
    dismiss_and_render(params)
  end

  def follow
    dismiss_and_render(params) {
      current_user.twitter_client.follow(params[:id].to_i)
    }
  end
  
  def unfollow
    dismiss_and_render(params) {
      current_user.twitter_client.unfollow(params[:id].to_i)
    }
  end
  
  def say_hi
    dismiss_and_render(params) {
      current_user.twitter_client.update("Hi @#{params[:'screenName']} how are you today?")
    }
  end
  
  # def unfollow
  #   current_user.twitter_client.unfollow(params[:id].to_i)
  #   dismiss_and_redirect(params[:id])
  # end
  
  # def say_hi
  #   current_user.twitter_client.update("Hi @#{params[:screen_name]} how are you today?")
  #   dismiss_and_redirect(params[:id])
  # end

  private

  def dismiss_and_render(params, &block)
    Follow.update_all({dismissed_on: Time.now}, {user_id: current_user.id, follower_uid: params[:id]})
    block.call if block
    unfollower = (params[:type] == 'unfollower')
    member = unfollower ? current_user.new_unfollowers(1, 2).first : current_user.new_followers(1, first_login?, 2).first
    render partial: 'member', 
           locals: {
             member: member, 
             unfollower: unfollower, 
             engaged: current_user.mentions([member.attrs[:id]]).any?
    }
  end

  def check_current_user
    redirect_to root_url unless current_user
  end

  def first_login?
    cookies[:first_login] == 'true'
  end
end
