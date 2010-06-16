class AddIntelligenceToSubscriberLists < ActiveRecord::Migration
  def self.up
    create_table :relationships_subscriber_lists, :id => false do |t|; t.references :subscriber_list, :relationship; end
    create_table :company_types_subscriber_lists, :id => false do |t|; t.references :subscriber_list, :company_type; end
    create_table :sectors_subscriber_lists, :id => false do |t|; t.references :subscriber_list, :sector; end
  end

  def self.down
    drop_table :subscriber_lists_relationships
    drop_table :subscriber_lists_company_types
    drop_table :subscriber_lists_sectors
  end
end
