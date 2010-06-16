class CreateCampaignSubscribers < ActiveRecord::Migration
  def self.up
    create_table :campaign_recipients do |t|
      t.references :campaign, :recipient, :subscriber_list
      t.string  :recipient_type
      t.boolean :sent_email, :default => false
      t.boolean :active, :default => true
      t.boolean :visible, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :campaign_recipients
  end
end
