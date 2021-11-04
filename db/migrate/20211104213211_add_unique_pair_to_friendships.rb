class AddUniquePairToFriendships < ActiveRecord::Migration[6.1]
  def change
    add_index :friendships, [:sent_to_id, :sent_by_id], :unique => true
  end
end
