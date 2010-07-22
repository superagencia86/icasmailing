class InstitutionType < ActiveRecord::Base
  default_scope :order => :name
  validates_presence_of :name
end
