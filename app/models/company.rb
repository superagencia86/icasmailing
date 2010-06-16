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

end
