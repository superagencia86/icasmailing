class AddParanoidToPrincipalTables < ActiveRecord::Migration
  def self.up
    add_column :companies, :deleted_at, :datetime
    add_column :contacts,  :deleted_at, :datetime
    add_column :proposals, :deleted_at, :datetime
    add_column :projects,  :deleted_at, :datetime
  end

  def self.down
    remove_column :companies, :deleted_at
    remove_column :contacts,  :deleted_at
    remove_column :proposals, :deleted_at
    remove_column :projects,  :deleted_at
  end
end
