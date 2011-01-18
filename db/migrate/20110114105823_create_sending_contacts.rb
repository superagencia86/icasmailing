class CreateSendingContacts < ActiveRecord::Migration
  def self.up
    create_table :sending_contacts do |t|
      t.references :campaign, :null => false
      t.references :sending, :null => false
      t.references :contact, :null => false
      t.string :email, :null => false
      t.string :status, :length => 16, :default => 'pending', :null => false
      t.timestamps
    end

    add_column :sendings, :subscriber_list_id, :integer
    add_index :sending_contacts, :campaign_id
    add_index :sending_contacts, :email

    Sending.all.each do |sending|
      puts "Envío de #{sending.campaign.name}"
      sending.subscriber_lists.each do |list|
        puts "Lista de suscripción"
        list.contacts.each do |contact|
          SendingContact.create!(:campaign => sending.campaign, :sending => sending,
            :contact => contact, :status => 'sent', :email => contact.email)
        end
      end
    end


  end

  def self.down
    drop_table :sending_contacts
    remove_column :sendings, :subscriber_list_id
  end
end
