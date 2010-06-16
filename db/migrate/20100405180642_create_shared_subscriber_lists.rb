class CreateSharedSubscriberLists < ActiveRecord::Migration
  def self.up
    create_table :shared_lists do |t|
      t.integer :subscriber_list_id, :space_id
      t.date    :expires_at
    end
  end

  def self.down
    drop_table :shared_lists
  end
end
