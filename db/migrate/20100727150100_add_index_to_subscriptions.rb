class AddIndexToSubscriptions < ActiveRecord::Migration
  def self.up
    add_index :subscribers, :subscriber_list_id
    add_index :subscribers, [:subscriber_list_id, :active]
    add_index :contacts, :contact_type_id
    add_index :contacts, :institution_type_id
    add_index :contacts, :space_id
  end

  def self.down
    remove_index :subscribers, :subscriber_list_id
    remove_index :subscribers, [:subscriber_list_id, :active]
    remove_index :contacts, :contact_type_id
    remove_index :contacts, :institution_type_id
    remove_index :contacts, :space_id
  end
end
