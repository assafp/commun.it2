class User < ActiveRecord::Base
  attr_accessible :name, :uid, :token, :secret

  has_many :follows

  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end
  end

  def twitter_client
    @twitter_client ||= create_twitter_client
  end

  def update_follows
    possible_unfollower_ids = follows.where(unfollowed_on: nil).map(&:follower_uid).to_set
    latest_follow = follows.order('follow_index DESC').first
    current_follow_index = latest_follow ? latest_follow.follow_index : 0
    new_follower_ids = []
    twitter_client.follower_ids.each do |follower_id|
      new_follower_ids << follower_id unless possible_unfollower_ids.delete?(follower_id)
    end
    new_follower_ids.reverse_each {|follower_id| create_follow(follower_id, current_follow_index += 1)}
    Follow.update_all({unfollowed_on: Time.now}, {user_id: id, follower_uid: possible_unfollower_ids.to_a})
  end

  def new_followers(first_login)
    if first_login
      count = (follows.count / 10.0).ceil # On his first login we’ll assume that the last 10% of the followers that Twitter returned to us are new
      ids = follows.where(unfollowed_on: nil).order('follow_index DESC').limit([3,count].min).map(&:follower_uid)
    else
      ids = follows.where(unfollowed_on: nil).order('follow_index DESC').limit(3).map(&:follower_uid)
    end
    twitter_client.users(ids) || []
  end

  def new_unfollowers
    ids = follows.where('unfollowed_on IS NOT NULL').order('unfollowed_on DESC').limit(3).map(&:follower_uid)
    twitter_client.users(ids) || []
  end

  private

  def create_twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONSUMER[:key]
      config.consumer_secret     = TWITTER_CONSUMER[:secret]
      config.access_token        = token
      config.access_token_secret = secret
    end
  end

  def create_follow(follower_id, current_follow_index)
    if existing_follow = follows.find_by_follower_uid(follower_id)
      existing_follow.update_attributes({unfollowed_on: nil, follow_index: current_follow_index})
    else 
      follows.create! do |follow|
        follow.follower_uid = follower_id
        follow.follow_index = current_follow_index
      end
    end
  end
end
