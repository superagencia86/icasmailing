class Company < ActiveRecord::Base
  acts_as_paranoid
  record_activity_of :user

  belongs_to :user
  has_many :contacts
  has_many :projects
  has_many :proposals

  has_many :comments, :as => :commentable

  has_and_belongs_to_many :company_types
  has_and_belongs_to_many :relationships
  has_and_belongs_to_many :sectors
  
  validates_presence_of :name
  validates_uniqueness_of :name

  default_scope :order => 'name ASC'

  simple_column_search :name, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  def self.finder(options = {})
    conditions = []

    %w(company_type relationship sector).each do |field|
      conditions << "#{field}_id in (#{options["#{field}".to_sym].join(',')})" if options["#{field}".to_sym].present?
    end

    if conditions.present?
      Company.find(
        :all, 
        :joins => "LEFT JOIN companies_company_types ON companies_company_types.company_id = companies.id LEFT JOIN companies_sectors ON companies_sectors.company_id = companies.id LEFT JOIN companies_relationships ON companies_relationships.company_id = companies.id",
        :group => 'companies.id',
        :conditions => conditions.join(" OR ")
      )
    end
  end
end
