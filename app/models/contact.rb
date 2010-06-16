class Contact < ActiveRecord::Base
  acts_as_paranoid
  record_activity_of :user, :if => Proc.new{|user| user.visibility != 'private'}

  belongs_to :user
  belongs_to :company
  has_many :comments, :as => :commentable
  
  has_and_belongs_to_many :hobbies
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email

  default_scope :order => 'name ASC, surname ASC'

  named_scope :public, :conditions => {:visibility => 'public'}
  named_scope :private, :conditions => {:visibility => 'private'}
  named_scope :for, Proc.new{|user| {:conditions => ["user_id = ? and visibility = 'private' OR visibility = 'public'", user.id]}}

  simple_column_search :name, :surname, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  def full_name
    "#{name} #{surname}"
  end
  
  def self.finder(options = {})
    conditions = []

    %w(contact_type_id contact_subtype_id).each do |field|
      conditions << "#{field} = #{options["#{field}".to_sym]}" if options["#{field}".to_sym].present?
    end
    
    if options[:hobby].present?
      conditions << "hobby_id IN (#{options[:hobby].join(',')})"
      joins = "LEFT JOIN contacts_hobbies ON contacts_hobbies.contact_id = contacts.id" if options[:hobby]
    else
      joins = ""
    end

    if conditions.present?
      Contact.find(
        :all,
        :joins => joins,
        :group => 'contacts.id',
        :conditions => conditions.join(" AND ")
      )
    end
  end
  
  
  def before_save
    self.contact_subtype_id = nil if self.contact_type_id != 2
  end
end
