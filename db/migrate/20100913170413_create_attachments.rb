class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :email_attachments do |t|
      t.integer  :campaign_id
      t.string   :data_type
      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.datetime :data_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :email_attachments
  end
end
