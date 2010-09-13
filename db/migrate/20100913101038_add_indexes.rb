class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :campaign_recipients, [:recipient_id, :campaign_id]
  end

  def self.down
    remove_index :campaign_recipients, [:recipient_id, :campaign_id]
  end
end
