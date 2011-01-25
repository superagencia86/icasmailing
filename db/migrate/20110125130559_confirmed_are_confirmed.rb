class ConfirmedAreConfirmed < ActiveRecord::Migration
  def self.up
    space = Space.find_by_name("Confirmados ICAS")
    space.contacts.each do |contact|
      contact.update_attribute(:confirmed, true)
    end
  end

  def self.down
  end
end
