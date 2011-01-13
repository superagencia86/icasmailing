class AddDescriptionToLists < ActiveRecord::Migration
  def self.up
    add_column :subscriber_lists, :description, :string, :limit => 1024
  end

  def self.down
    remove_column :subscriber_lists, :description
  end
end
