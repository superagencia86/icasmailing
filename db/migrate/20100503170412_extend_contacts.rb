class ExtendContacts < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :sex_id, :integer
    add_column :subscribers, :job, :string
    add_column :subscribers, :web, :string
    add_column :subscribers, :celular, :string
    add_column :subscribers, :telephone, :string
    add_column :subscribers, :birthday_at, :date
    add_column :subscribers, :address, :text
    add_column :subscribers, :locality, :string
    add_column :subscribers, :subscriber_type_id, :integer
    add_column :subscribers, :subscriber_subtype_id, :integer
    
    create_table :hobbies do |t|
      t.string :name
    end
    
    %w(Danza Música Teatro Cine Artes\ plásticas\ (pintura,\ escultura,\ fotografía...) Libros Otros).each do |name|
      Hobby.create(:name => name)
    end
    
    create_table :hobbies_subscribers, :id => false do |t|
      t.references :subscriber, :hobby
    end
  end

  def self.down
    remove_column :subscribers, :sex_id
    remove_column :subscribers, :job
    remove_column :subscribers, :web
    remove_column :subscribers, :celular
    remove_column :subscribers, :telephone
    remove_column :subscribers, :birthday_at
    remove_column :subscribers, :address
    remove_column :subscribers, :locality
    remove_column :subscribers, :subscriber_type_id
    remove_column :subscribers, :subscriber_subtype_id
    
    drop_table :hobbies
    drop_table :hobbies_subscribers     
  end
end
