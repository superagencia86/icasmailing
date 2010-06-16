class CreateSubscriberLists < ActiveRecord::Migration
  def self.up
    create_table :subscriber_lists do |t|
      t.integer :space_id
      t.string :name
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :subscriber_lists
  end
end
