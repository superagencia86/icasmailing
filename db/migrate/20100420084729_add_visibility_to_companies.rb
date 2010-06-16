class AddVisibilityToCompanies < ActiveRecord::Migration
  def self.up
    add_column :contacts, :visibility, :string, :default => 'public'
    Contact.update_all("visibility = 'public'")
  end

  def self.down
    remove_column :contacts, :visibility
  end
end
