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
  
  has_many :subscriber_contacts, :through => :subscribers, :source => :contact
  
  has_many :confirmed, :through => :subscribers, :source => :contact,
    :conditions => {:confirmed => true}
  has_many :active_subscribers, :class_name => 'Subscriber', :conditions => {:active => true}
  has_many :active_contacts, :through => :active_subscribers, :source => :contact

  has_and_belongs_to_many :hobbies
  has_and_belongs_to_many :institution_types

  has_many :shared_lists

  def contacts
    auto_update? ? filter.contacts : subscriber_contacts
  end

  def contacts_count
    auto_update? ? filter.length : subscribers.length
  end

  def filter
    @filter ||= ContactFilter.new(self)
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

  def info
    contacts = auto_update? ? 'lista inteligente' : "#{self.contacts_count} contactos"
    "#{self.space.name} - #{self.name} (#{contacts})"
  end

  protected
  def clone_list_if_specified
    if @clone_list_id.present?
      puts "CLONE! #{@clone_list_id}"
      other = SubscriberList.find @clone_list_id
      self.contacts << other.contacts
      self.save!
    end
  end
end
