class AddSubscribersCountToSubscriberLists < ActiveRecord::Migration
  def self.up
    add_column :subscriber_lists, :subscribers_count, :integer, :default => 0

    SubscriberList.reset_column_information
    SubscriberList.find(:all).each do |sl|
      SubscriberList.update_counters sl.id, :subscribers_count => sl.subscribers.length
    end
  end

  def self.down
    remove_column :subscriber_lists, :subscribers_count
  end
end
