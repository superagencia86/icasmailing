class AddUserIdToSubscriptionLists < ActiveRecord::Migration
  def self.up
    add_column :subscriber_lists, :user_id, :integer
    SubscriberList.update_all({:user_id => User.first.id})
  end

  def self.down
    remove_column :subscription_lists, :user_id
  end
end
