class AddCampaignsSubscriberListsTable < ActiveRecord::Migration
  def self.up
    create_table :campaigns_subscriber_lists, :id => false do |t|
      t.integer :campaign_id
      t.integer :subscriber_list_id
    end
  end

  def self.down
    drop_table :campaigns_subscriber_lists
  end
end
