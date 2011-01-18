class SendWithDuplicateEmails < ActiveRecord::Migration
  def self.up
    add_column :sendings, :send_duplicates, :boolean, :default => false
  end

  def self.down
    remove_column :sendings, :send_duplicates
  end
end
