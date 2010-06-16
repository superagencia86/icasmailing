class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.integer :subscriber_list_id
      t.string :name
      t.string :first_surname
      t.string :second_surname
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribers
  end
end
