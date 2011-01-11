


class Contact < ActiveRecord::Base
  SUBSCRIBER_TYPES = os_array(["Público general", "Medios de comunicación", "Artista - profesional", "Instituciones"])
  SUBSCRIBER_SUBTYPES = os_array(["Organismo público", "Responsable político", "Empresa privada", "Espacio cultural", "Artista", "ICAS"])

  acts_as_paranoid
  record_activity_of :user, :if => Proc.new{|contact| !contact.from_form }

  belongs_to :user
  belongs_to :company
  belongs_to :space
  
  has_and_belongs_to_many :hobbies
  has_many :subscribers
  has_many :subscriber_lists, :through => :subscribers
  
  # validates_presence_of :name, :email, :user_id, :space_id
  validates_presence_of :email, :user_id, :space_id
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  default_scope :order => 'contacts.name ASC, surname ASC'

  named_scope :public, :conditions => {:visibility => 'public'}
  named_scope :private, :conditions => {:visibility => 'private'}
  named_scope :for, Proc.new{|user| {:conditions => ["user_id = ? and visibility = 'private' OR visibility = 'public'", user.id]}}

  # Contact types
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
  
  def self.finder(options = {})
    conditions, joins = [], ""

    conditions << "space_id = #{options[:space_id]}" if options[:space_id].present?
    conditions << ["name LIKE '%#{options[:query]}%' OR surname LIKE '%#{options[:query]}%' OR email LIKE '%#{options[:query]}%'"] if options[:query].present?

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

  def confirmation_code
    "#{id}/#{Digest::MD5.hexdigest(id.to_s)}"
  end

  def self.import(excel, user)
    excel = Spreadsheet.open(excel)
    values = excel.worksheet 0
    user_added = []
    user_no_added = []
    hobbies = Hobby.all

    values.each_with_index do |contact, index|
      next if index == 0
      contact, added = import_contact(contact, :hobbies => hobbies, :user => user)

      if added
        user_added << contact.try(:id)
      else
        user_no_added << contact.try(:id)
      end
    end

    [user_added, user_no_added]
  end

  def self.import_contact(contact, options = {})
    if !contact[0].nil?
      new_contact = { 
        :user => options[:user],
        :space => options[:user].space,
        :email => contact[0],
        :name => contact[1],
        :surname => contact[2],
        :entidad => contact[3],
        :contact_type_id => SUBSCRIBER_TYPES.detect{|x| x.name == contact[4]}.try(:idx),
        :institution_type_id => (InstitutionType.find_by_name(contact[5]) if contact[4].present?),
        :hobby_ids => set_hobbies(contact[6], options[:hobbies]),
        :job => contact[7],
        :sex_id => SEX.detect{|x| x.name == contact[8]}.try(:idx),
        :web => contact[9],
        :celular => contact[10].try(:to_i),
        :telephone => contact[11].try(:to_i),
        :birthday_at => (contact.date(12) if contact[12].present?),
        :address => contact[13],
        :province_id => PROVINCES.detect{|x| x.name == contact[14]}.try(:idx),
        :locality => contact[15],
        :zip => contact[16].try(:to_i),
        :comments => contact[17]
      }

      contact = Contact.new(new_contact)
      if contact.save
        [contact, true]
      else
        [Contact.find_by_email(contact.email), false]
      end
    end
  end

  def self.set_hobbies(hobbies_from_excel, hobbies_from_db)
    ids = []

    if hobbies_from_excel.present?
      hobbies_from_excel.split(",").each do |hobby|
        value = Hobby::FROM_EXCEL[hobby]
        ids << hobbies_from_db.detect{|x| x.name == value}.try(:id)
      end
    end

    ids
  end
end
