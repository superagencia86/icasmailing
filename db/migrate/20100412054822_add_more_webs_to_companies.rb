class AddMoreWebsToCompanies < ActiveRecord::Migration
  def self.up
    rename_column :companies, :web, :web_1
    add_column :companies, :web_2, :string
    add_column :companies, :web_3, :string
    add_column :companies, :address_mailing, :text
    add_column :companies, :address_billing, :text 
  end

  def self.down
    rename_column :companies, :web_1, :web
    remove_column :companies, :web_2
    remove_column :companies, :web_3
    remove_column :companies, :address_mailing
    remove_column :companies, :address_billing
  end
end
