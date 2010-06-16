class RevolutionCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.integer :space_id
      t.string  :name
      t.string  :locality
      t.integer :province_id
      t.string  :country
      t.string  :phone_1
      t.string  :phone_2
      t.string  :phone_3
      t.string  :fax
      t.text    :address
      t.string  :web
      t.string  :email
      t.string  :state
      t.date    :last_contact_on
      t.integer :assigned_to
      t.integer :user_id

      t.timestamps
    end

    create_table :relationships do |t|; t.string :name; end
    create_table :company_types do |t|; t.string :name; end
    create_table :sectors do |t|; t.string :name; end
    create_table :companies_relationships, :id => false do |t|; t.references :company, :relationship; end
    create_table :companies_company_types, :id => false do |t|; t.references :company, :company_type; end
    create_table :companies_sectors, :id => false do |t|; t.references :company, :sector; end

  end

  def self.down
    drop_table :companies
    drop_table :relationships 
    drop_table :company_types
    drop_table :sectors 
    drop_table :companies_relationships
    drop_table :companies_customer_types
    drop_table :companies_sectors
  end
end
