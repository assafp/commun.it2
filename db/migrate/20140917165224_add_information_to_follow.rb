class AddInformationToFollow < ActiveRecord::Migration
  def change
    add_column :follows, :unfollowed_on, :datetime
    add_column :follows, :follow_index, :integer
    add_column :follows, :dismissed_on, :datetime
  end
end
