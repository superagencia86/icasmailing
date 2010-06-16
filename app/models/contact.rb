class Contact < ActiveRecord::Base
  acts_as_paranoid
  record_activity_of :user, :if => Proc.new{|user| user.visibility != 'private'}

  belongs_to :user
  belongs_to :company
  has_many :comments, :as => :commentable

  validates_presence_of :name, :company_id
  validates_uniqueness_of :email

  default_scope :order => 'name ASC, surname ASC'

  named_scope :public, :conditions => {:visibility => 'public'}
  named_scope :private, :conditions => {:visibility => 'private'}
  named_scope :for, Proc.new{|user| {:conditions => ["user_id = ? and visibility = 'private' OR visibility = 'public'", user.id]}}

  simple_column_search :name, :surname, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  def full_name
    "#{name} #{surname}"
  end
end
