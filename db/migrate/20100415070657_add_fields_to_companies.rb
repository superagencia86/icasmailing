class AddFieldsToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :cif, :string
    add_column :companies, :social_name, :string
  end

  def self.down
    remove_column :companies, :social_name
    remove_column :companies, :cif
  end
end
