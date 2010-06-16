class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :name
      t.string :surname
      t.string :title
      t.string :section
      t.string :email
      t.string :secondary_email
      t.string :phone
      t.string :celular

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
