class AddHabtmInstitution < ActiveRecord::Migration
  def self.up
    create_table :institution_types_subscriber_lists, :id => false do |t|
      t.integer :institution_type_id, :subscriber_list_id
    end

    change_table :subscriber_lists do |t|
      t.boolean :all_general, :all_institutions, :all_comunication, :all_artists
      t.boolean :updating_contacts, :default => true
    end
  end

  def self.down
    drop_table :institution_types_subscriber_lists
    remove_column :subscriber_lists, :all_general, :all_institutions, :all_comunication, :all_artists
  end
end
