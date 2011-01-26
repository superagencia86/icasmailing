


class Contact < ActiveRecord::Base
  SUBSCRIBER_TYPES = os_array(["Público general", "Medios de comunicación", "Artista - profesional", "Instituciones"])
  SUBSCRIBER_SUBTYPES = os_array(["Organismo público", "Responsable político", "Empresa privada", "Espacio cultural", "Artista", "ICAS"])
  after_destroy :unconfirm_if_confirmed
  acts_as_paranoid
  record_activity_of :user, :if => Proc.new{|contact| !contact.from_form }

  belongs_to :user
  belongs_to :company
  belongs_to :space
  belongs_to :institution_type
  
  has_and_belongs_to_many :hobbies
  has_many :subscribers, :dependent => :destroy
  has_many :subscriber_lists, :through => :subscribers
  
  validates_presence_of :email, :scope => :space_id
  validates_presence_of :user_id, :space_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  default_scope :order => 'contacts.name ASC, surname ASC, email ASC'

  named_scope :public, :conditions => {:visibility => 'public'}
  named_scope :private, :conditions => {:visibility => 'private'}
  named_scope :for, Proc.new{|user| {:conditions => ["user_id = ? and visibility = 'private' OR visibility = 'public'", user.id]}}

  # Contact types
  named_scope :confirmed, :conditions => {:confirmed => true}
  named_scope :general, :conditions => {:contact_type_id => 1}
  named_scope :comunication, :conditions => {:contact_type_id => 2}
  named_scope :artist, :conditions => {:contact_type_id => 3}
  named_scope :institution, :conditions => {:contact_type_id => 4}
  named_scope :for_space, Proc.new{|space_id| {:conditions => ["contacts.space_id = ?", space_id]}}


  simple_column_search :name, :surname, :email, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  def full_name
    res = "#{name} #{surname}" 
    res.present? ? res : self.email
  end

  # to search
  def self.finder(options = {})
    conditions, joins = [], ""

    options[:space_id] = options[:space].id if options[:space].present?

    conditions << "space_id = #{options[:space_id]}" if options[:space_id].present?

    if options[:query].present?
      options[:query].split.each do |query|
        conditions << ["(name LIKE '%#{query}%' OR surname LIKE '%#{query}%' OR email LIKE '%#{query}%')"]
      end
    end

    %w(contact_type_id contact_subtype_id).each do |field|
      conditions << "#{field} = #{options["#{field}".to_sym]}" if options["#{field}".to_sym].present?
    end

    if options[:hobby].present?
      conditions << "#{options[:hobby].length} = all (select count(contact_id) from contacts_hobbies 
        where hobby_id IN (#{options[:hobby].join(',')}) GROUP BY contacts_hobbies.contact_id)"
      joins = "LEFT JOIN contacts_hobbies ON contacts_hobbies.contact_id = contacts.id" 
    end

    Contact.find(:all, :joins => joins, :group => 'contacts.id', :conditions => conditions.join(" AND "), :limit => 30) if conditions.present?
  end
  
  
  def before_save
    self.contact_subtype_id = nil if self.contact_type_id != 2
  end

  def confirmation_code
    "#{id}/#{Digest::MD5.hexdigest(id.to_s)}"
  end


  # Confirm a contact
  def confirm
    # Create the contact in the confirmed space
    cicas = Space.confirmed
    confirmed = cicas.contacts.find_by_email(self.email)
    if !confirmed
      confirmed = self.clone
      confirmed.space = cicas
      confirmed.confirmed = true
      confirmed.save!
    end

    # Confirmar todos los contactos con el mismo email
    Contact.find_all_by_email(self.email).each do |contact|
      contact.update_attribute(:confirmed, true)
    end
    self.update_attribute(:confirmed, true)
  end

  def unconfirm
    cicas = Space.confirmed

    # Quitar la confirmación de los contactos
    Contact.find_all_by_email(self.email).each do |contact|
      contact.update_attribute(:confirmed, false)
    end

    confirmed = cicas.contacts.find_by_email(self.email)
    confirmed.destroy if confirmed
  end

  protected
  def unconfirm_if_confirmed
    if self.space == Space.confirmed
      Contact.find_all_by_email(self.email).each do |contact|
        contact.update_attribute(:confirmed, false)
      end
    end
  end

end
