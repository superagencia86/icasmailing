class AddIndexToSubscriptions < ActiveRecord::Migration
  def self.up
    add_index :subscribers, :subscriber_list_id
    add_index :subscribers, [:subscriber_list_id, :active]
  end

  def self.down
    remove_index :subscribers, :subscriber_list_id
    remove_index :subscribers, [:subscriber_list_id, :active]
  end
end
