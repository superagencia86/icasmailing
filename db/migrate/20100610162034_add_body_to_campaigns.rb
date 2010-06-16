class AddBodyToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :body, :text
  end

  def self.down
    remove_column :campaigns, :body
  end
end
