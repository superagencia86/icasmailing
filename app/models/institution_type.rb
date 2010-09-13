class InstitutionType < ActiveRecord::Base
  default_scope :order => :name
  validates_presence_of :name

  simple_column_search :name, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }
end
