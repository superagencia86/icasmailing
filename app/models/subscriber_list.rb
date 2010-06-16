class SubscriberList < ActiveRecord::Base
  has_many :subscribers
  belongs_to :space
  belongs_to :shares_space, :class_name => 'Space'
  has_many :comments, :as => :commentable

  has_and_belongs_to_many :company_types
  has_and_belongs_to_many :relationships
  has_and_belongs_to_many :sectors

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
    self.company_types.present? || self.relationships.present? || self.sectors.present?
  end

  def companies
    Company.finder(:company_type => self.company_type_ids, :relationship => self.relationship_ids, :sector => self.sector_ids)
  end

end
