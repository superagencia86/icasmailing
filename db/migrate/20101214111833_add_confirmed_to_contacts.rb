class AddConfirmedToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :confirmed, :boolean, :default => false
  end

  def self.down
    remove_column :contacts, :confirmed
  end
end
