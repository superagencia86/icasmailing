class CreateSendings < ActiveRecord::Migration
  def self.up
    create_table :sendings do |t|
      t.references :campaign
      t.string :current_state, :default => "new"
      t.datetime :sent_at
      t.datetime :sent_starts_at
      t.timestamps
    end
    create_table(:sendings_subscriber_lists, :id => false) do |t|
      t.references :subscriber_list, :sending
    end

    add_column :campaign_recipients, :sending_id, :integer

    Campaign.find_each do |campaign|
      puts "Migrando: #{campaign.name} (#{campaign.campaign_recipients.size})"
      sending = Sending.create!(:campaign => campaign, 
        :sent_at => campaign.updated_at, :sent_starts_at => campaign.updated_at,
        :current_state => campaign.current_state)
      sending.subscriber_lists = campaign.subscriber_lists
      sending.save!
      recipients = 0
      campaign.campaign_recipients.find_each do |recipient|
        recipients += 1
        puts "." if recipients % 10 == 0
        recipient.update_attribute(:sending_id, sending.id)
      end
      puts("Sending con #{sending.campaign_recipients.size} envíos")
    end
  end

  def self.down
    drop_table :sendings
    remove_column :campaign_recipients, :sending_id
  end
end
