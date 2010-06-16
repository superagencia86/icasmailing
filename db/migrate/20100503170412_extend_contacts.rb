class ExtendContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :sex_id, :integer
    add_column :contacts, :job, :string
    add_column :contacts, :web, :string
    add_column :contacts, :telephone, :string
    add_column :contacts, :birthday_at, :date
    add_column :contacts, :address, :text
    add_column :contacts, :locality, :string
    add_column :contacts, :province_id, :integer
    add_column :contacts, :contact_type_id, :integer
    add_column :contacts, :contact_subtype_id, :integer
    
    create_table :hobbies do |t|
      t.string :name
    end
    
    %w(Danza Música Teatro Cine Artes\ plásticas\ (pintura,\ escultura,\ fotografía...) Libros Otros).each do |name|
      Hobby.create(:name => name)
    end
    
    create_table :contacts_hobbies, :id => false do |t|
      t.references :contact, :hobby
    end
  end

  def self.down
    remove_column :contacts, :sex_id
    remove_column :contacts, :job
    remove_column :contacts, :web
    remove_column :contacts, :celular
    remove_column :contacts, :telephone
    remove_column :contacts, :birthday_at
    remove_column :contacts, :address
    remove_column :contacts, :locality
    remove_column :contacts, :subscriber_type_id
    remove_column :contacts, :subscriber_subtype_id
    
    drop_table :hobbies
    drop_table :contacts_hobbies
  end
end
