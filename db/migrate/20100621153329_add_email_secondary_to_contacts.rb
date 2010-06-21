class AddEmailSecondaryToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :email_secondary, :string
    add_column :contacts, :comments, :text
  end

  def self.down
    remove_column :contacts, :email_secondary
    remove_column :contacts, :comments
  end
end
