class AddExcelToSubscribers < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :excel, :boolean, :default => false
  end

  def self.down
    remove_column :subscribers, :excel
  end
end
