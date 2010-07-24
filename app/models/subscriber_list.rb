class SubscriberList < ActiveRecord::Base
  attr_accessor :active
  CONTACTS_PER_PAGE = 30
  belongs_to :space
  belongs_to :shares_space, :class_name => 'Space'
  has_many :comments, :as => :commentable
  
  has_many :subscribers
  has_many :contacts, :through => :subscribers
  has_many :active_subscribers, :class_name => 'Subscriber', :conditions => {:active => true}
  has_many :active_contacts, :through => :active_subscribers, :source => :contact

  has_and_belongs_to_many :hobbies
  has_and_belongs_to_many :institution_types

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :space_id

  def process_subscribers(subscribers)
    subscribers.each do |subscriber|
      email, name, surname = subscriber.split(",")
      subscriber = Subscriber.find_or_initialize_by_email(email)
      subscriber.attributes = {:name => name.strip, :surname => surname.strip, :subscriber_list => self}
      subscriber.save!
    end
  end

  def has_finder?
    self.hobbies.present? || self.contact_type_id.present?
  end
  
  def before_save
    self.contact_subtype_id = nil if self.contact_type_id != 2
  end

  def update_assigned_contacts
    contact_ids = []
    # General
      if self.all_general
        contact_ids += Contact.general.find(:all, :select => :id).map(&:id)
      else
        if self.hobbies.present?
          contact_ids += Contact.general.find(:all, :joins => :hobbies, :conditions => ["hobbies.id IN (#{self.hobbies.map(&:id).join(', ')})"]).map(&:id)
        end
      end
    # Comunication
      contact_ids += Contact.comunication.map(&:id) if self.all_comunication
    # Institutions
      institutions = self.institution_types
      if self.all_institutions
        contact_ids += Contact.institution.map(&:id)
      else
        if institutions.present?
          contact_ids += Contact.institution.find(:all, :conditions => ["institution_type_id IN (#{institutions.map(&:id).join(', ')})"], :select => 'id').map(&:id)
        end
      end
    # Artists
      contact_ids += Contact.artist.map(&:id) if self.all_artists

    self.update_attribute(:contact_ids, contact_ids)
  end
end
