class MoreOptionsToSendings < ActiveRecord::Migration
  def self.up
    add_column :sendings, :source_type, :string, :limit => 8
    add_column :sendings, :space_id, :integer
    add_column :sendings, :shared_list_id, :integer
    add_column :sendings, :confirmed_space_id, :integer
    add_column :sendings, :source_description, :string, :limit => 120
  end

  def self.down
    remove_column :sendings, :source_type
    remove_column :sendings, :space_id
    remove_column :sendings, :shared_list_id
    remove_column :sendings, :confirmed_space_id
    remove_column :sendings, :source_description
  end
end
