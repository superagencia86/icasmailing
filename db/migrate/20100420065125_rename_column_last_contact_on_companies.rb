class RenameColumnLastContactOnCompanies < ActiveRecord::Migration
  def self.up
    rename_column :companies, :last_contact_on, :last_contact
    change_column :companies, :last_contact, :string
  end

  def self.down
    rename_column :companies, :last_contact, :last_contact_on
  end
end
