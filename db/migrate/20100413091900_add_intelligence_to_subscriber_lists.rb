class AddIntelligenceToSubscriberLists < ActiveRecord::Migration
  def self.up
    add_column :subscriber_lists, :contact_type_id, :integer
    add_column :subscriber_lists, :contact_subtype_id, :integer
    create_table :hobbies_subscriber_lists, :id => false do |t|; t.references :subscriber_list, :hobby; end
  end

  def self.down
    remove_column :subscriber_lists, :contact_type_id
    remove_column :subscriber_lists, :contact_subtype_id
    drop_table :hobbies_subscriber_lists
  end
end
