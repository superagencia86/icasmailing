class AddFieldsToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :zip, :string
  end

  def self.down
    remove_column :contacts, :zip
  end
end
