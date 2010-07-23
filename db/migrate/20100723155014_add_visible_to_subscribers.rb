class AddVisibleToSubscribers < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :active, :boolean, :default => true
  end

  def self.down
    remove_column :subscribers, :active
  end
end
