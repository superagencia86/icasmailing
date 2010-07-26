class AddSpaceIdToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :space_id, :integer
  end

  def self.down
    remove_column :contacts, :space_id
  end
end
