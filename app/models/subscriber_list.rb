class SubscriberList < ActiveRecord::Base
  has_many :subscribers
  belongs_to :space
  belongs_to :shares_space, :class_name => 'Space'
  has_many :comments, :as => :commentable

  has_and_belongs_to_many :hobbies

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

  def contacts
    Contact.finder(:contact_type_id => self.contact_type_id, :contact_subtype_id => self.contact_subtype_id, :hobby => self.hobby_ids)
  end
  
  def before_save
    self.contact_subtype_id = nil if self.contact_type_id != 2
  end
end
