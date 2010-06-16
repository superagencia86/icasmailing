class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
