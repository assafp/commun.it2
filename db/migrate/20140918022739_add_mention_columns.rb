class AddMentionColumns < ActiveRecord::Migration
  def change
    add_column :follows, :mention_on, :datetime
    add_column :users, :last_mention_id, :integer
  end
end
