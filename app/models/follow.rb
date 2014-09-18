class Follow < ActiveRecord::Base
  attr_accessible :unfollowed_on, :follow_index
  
  belongs_to :user
end
