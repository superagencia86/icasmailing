class Contact < ActiveRecord::Base
  SUBSCRIBER_TYPES = os_array(["Publico general", "Medios de comunicación", "Artista - profesional", "Instituciones"])
  SUBSCRIBER_SUBTYPES = os_array(["Organismo público", "Responsable político", "Empresa privada", "Espacio cultural", "Artista", "ICAS"])

  acts_as_paranoid
  record_activity_of :user, :if => Proc.new{|contact| !contact.from_form }

  belongs_to :user
  belongs_to :company
  has_many :comments, :as => :commentable
  
  has_and_belongs_to_many :hobbies
  has_many :subscribers
  has_many :subscriber_lists, :through => :subscribers
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  default_scope :order => 'name ASC, surname ASC'

  named_scope :public, :conditions => {:visibility => 'public'}
  named_scope :private, :conditions => {:visibility => 'private'}
  named_scope :for, Proc.new{|user| {:conditions => ["user_id = ? and visibility = 'private' OR visibility = 'public'", user.id]}}

  # Contact types
  named_scope :general, :conditions => {:contact_type_id => 1}
  named_scope :comunication, :conditions => {:contact_type_id => 2}
  named_scope :artist, :conditions => {:contact_type_id => 3}
  named_scope :institution, :conditions => {:contact_type_id => 4}


  simple_column_search :name, :surname, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  def full_name
    "#{name} #{surname}"
  end
  
  def self.finder(options = {})
    conditions, joins = [], ""

    %w(contact_type_id contact_subtype_id).each do |field|
      conditions << "#{field} = #{options["#{field}".to_sym]}" if options["#{field}".to_sym].present?
    end

    if options[:hobby].present?
      conditions << "#{options[:hobby].length} = all (select count(contact_id) from contacts_hobbies 
        where hobby_id IN (#{options[:hobby].join(',')}) GROUP BY contacts_hobbies.contact_id)"
      joins = "LEFT JOIN contacts_hobbies ON contacts_hobbies.contact_id = contacts.id" 
    end

    Contact.find(:all, :joins => joins, :group => 'contacts.id', :conditions => conditions.join(" AND ")) if conditions.present?
  end
  
  
  def before_save
    self.contact_subtype_id = nil if self.contact_type_id != 2
  end
end
