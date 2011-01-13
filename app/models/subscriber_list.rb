class SubscriberList < ActiveRecord::Base
  CONTACTS_PER_PAGE = 30

  after_create :clone_list_if_specified
  default_scope :order => 'id DESC'

  attr_accessor :active

  validates_presence_of :name
  validates_presence_of :space
  validates_uniqueness_of :name, :scope => :space_id


  belongs_to :space
  belongs_to :shares_space, :class_name => 'Space'
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :user
  
  has_many :subscribers, :dependent => :destroy
  
  has_many :contacts, :through => :subscribers
  has_many :confirmed, :through => :subscribers, :source => :contact,
    :conditions => {:confirmed => true}
  has_many :active_subscribers, :class_name => 'Subscriber', :conditions => {:active => true}
  has_many :active_contacts, :through => :active_subscribers, :source => :contact

  has_and_belongs_to_many :hobbies
  has_and_belongs_to_many :institution_types

  has_many :shared_lists
  has_many :active_shared_lists, :conditions => ["expires_at >= ?", Date.today.to_s(:db)], :class_name => 'SharedList'


  def process_subscribers(subscribers)
    subscribers.each do |subscriber|
      email, name, surname = subscriber.split(",")
      subscriber = Subscriber.find_or_initialize_by_email(email)
      subscriber.attributes = {:name => name.strip, :surname => surname.strip, :subscriber_list => self}
      subscriber.save!
    end
  end

  def clone_list_id
    @clone_list_id
  end

  def clone_list_id=(id)
    @clone_list_id = id
  end

  def has_finder?
    self.hobbies.present? || self.contact_type_id.present?
  end

  def before_save
    self.contact_subtype_id = nil if self.contact_type_id != 2
  end

  def already_set?
    self.all_general.present? || self.all_institutions.present? || self.all_comunication.present? || self.all_artists.present? || self.hobbies.present? || self.institution_types.present?
  end

  def update_assigned_contacts
    contact_ids = Subscriber.find_all_by_subscriber_list_id_and_excel(self.id, true).map(&:contact_id)
    # General
    if self.all_general
      contact_ids += Contact.for_space(self.space.id).general.find(:all, :select => :id).map(&:id)
    else
      if self.hobbies.present?
        contact_ids += Contact.for_space(self.space.id).general.find(:all, :joins => :hobbies, :conditions => ["hobbies.id IN (#{self.hobbies.map(&:id).join(', ')})"]).map(&:id)
      end
    end
    # Comunication
    contact_ids += Contact.for_space(self.space.id).comunication.map(&:id) if self.all_comunication
    # Institutions
    institutions = self.institution_types
    if self.all_institutions
      contact_ids += Contact.for_space(self.space.id).institution.map(&:id)
    else
      if institutions.present?
        contact_ids += Contact.for_space(self.space.id).institution.find(:all, :conditions => ["institution_type_id IN (#{institutions.map(&:id).join(', ')})"], :select => 'id').map(&:id)
      end
    end
    # Artists
    contact_ids += Contact.for_space(self.space.id).artist.map(&:id) if self.all_artists

    self.update_attribute(:contact_ids, contact_ids)
  end

  protected
  def clone_list_if_specified
    puts "CLONE! #{@clone_list_id}"
    if @clone_list_id.present?
      other = SubscriberList.find @clone_list_id
      self.contacts << other.contacts
      self.save!
    end
  end
end
