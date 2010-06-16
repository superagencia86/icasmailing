class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.integer :space_id
      t.string :name
      t.string :subject
      t.string :reply_to
      t.string :from
      t.string :from_name
      t.string :current_state, :default => 'new'

      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
