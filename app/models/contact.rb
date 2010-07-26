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
  
  validates_presence_of :name, :email, :user_id, :space_id
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

  def self.import(excel, user)
    excel = Spreadsheet.open(excel)
    values = excel.worksheet 0
    user_added = []
    user_no_added = []
    hobbies = Hobby.all

    values.each_with_index do |contact, index|
      next if index == 0
      import_contact(contact, :hobbies => hobbies, :user => user, :user_added => user_added, :user_no_added => user_no_added)      
    end

    [user_added, user_no_added]
  end

  def self.import_contact(contact, options = {})
    if !contact[0].nil? && !contact[2].nil?
      new_contact = { 
        :user => options[:user],
        :space => options[:user].space,
        :name => contact[0],
        :surname => contact[1],
        :email => contact[2],
        :contact_type_id => SUBSCRIBER_TYPES.detect{|x| x.name == contact[3]}.try(:idx),
        :institution_type_id => InstitutionType.find_by_name(contact[4]),
        :hobby_ids => set_hobbies(contact[5], options[:hobbies]),
        :job => contact[6],
        :sex_id => SEX.detect{|x| x.name == contact[7]}.try(:idx),
        :web => contact[8],
        :celular => contact[9].to_i,
        :telephone => contact[10].to_i,
        :birthday_at => contact.date(11),
        :address => contact[12],
        :province_id => PROVINCES.detect{|x| x.name == contact[13]}.try(:idx),
        :locality => contact[14],
        :zip => contact[15].to_i,
        :comments => contact[16]
      }

      contact = Contact.new(new_contact)
      if contact.save
        options[:user_added] << contact.id
      else
        options[:user_no_added] << contact.id
      end
    end
  end

  def self.set_hobbies(hobbies_from_excel, hobbies_from_db)
    ids = []

    hobbies_from_excel.split(",").each do |hobby|
      value = Hobby::FROM_EXCEL[hobby]
      ids << hobbies_from_db.detect{|x| x.name == value}.try(:id)
    end

    ids
  end
end
