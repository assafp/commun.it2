class Follow < ActiveRecord::Base
  attr_accessible :unfollowed_on, :follow_index, :mention_on
  
  belongs_to :user
end
