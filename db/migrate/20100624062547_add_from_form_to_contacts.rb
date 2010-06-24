class AddFromFormToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :from_form, :boolean, :default => false
    add_column :contacts, :ip, :string
  end

  def self.down
    remove_column :contacts, :from_form
    remove_column :contacts, :ip
  end
end
