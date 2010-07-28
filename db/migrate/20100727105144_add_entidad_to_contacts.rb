class AddEntidadToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :entidad, :string
  end

  def self.down
    remove_column :contacts, :entidad
  end
end
