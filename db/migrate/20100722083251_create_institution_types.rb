class CreateInstitutionTypes < ActiveRecord::Migration
  def self.up
    create_table :institution_types do |t|
      t.string :name

      t.timestamps
    end

    add_column :contacts, :institution_type_id, :integer
  end

  def self.down
    drop_table :institution_types
    remove_column :contacts, :institution_type_id
  end
end
