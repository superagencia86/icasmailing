class Project < ActiveRecord::Base
  acts_as_paranoid
  record_activity_of :user

  belongs_to :user
  belongs_to :company
  has_many :comments, :as => :commentable

  validates_presence_of :name, :company_id

  simple_column_search :name, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }
end
