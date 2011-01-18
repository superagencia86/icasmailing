class AddAutoUpdateToSubscriberList < ActiveRecord::Migration
  def self.up
    add_column :subscriber_lists, :auto_update, :boolean
    remove_column :subscriber_lists, :updating_contacts
  end

  def self.down
    remove_column :subscriber_lists, :auto_update
    add_column :subscriber_lists, :updating_contacts, :boolean, :default => true
  end
end
