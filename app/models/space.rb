class Space < ActiveRecord::Base
  authenticates_many :user_sessions

  has_many :companies, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :subscriber_lists, :dependent => :destroy do
    def normal
      self.scoped_by_auto_update(false)
    end
  end
  # has_and_belongs_to_many :shared_lists, :join_table => 'shared_lists', :select => 'shared_lists.expires_at, subscriber_lists.space_id as shares_space_id, subscriber_lists.*', :conditions => ["expires_at >= ?", Date.today.to_s(:db)], :foreign_key => 'space_id', :association_foreign_key => 'subscriber_list_id', :class_name => "SubscriberList"
  has_and_belongs_to_many :shared_lists, :join_table => 'shared_lists', :select => 'subscriber_lists.space_id as shares_space_id, subscriber_lists.*', :foreign_key => 'space_id', :association_foreign_key => 'subscriber_list_id', :class_name => "SubscriberList"
  has_many :campaigns, :dependent => :destroy, :order => 'id DESC'

  validates_presence_of :name
  validates_uniqueness_of :name

  has_permalink :name, :update => true

  def to_param
    permalink
  end

  def valid_subscriber_lists(ids)
    (self.subscriber_list_ids + self.shared_list_ids) & ids.map{|i| i.to_i}
  end

  def shares_lists
    if self.subscriber_list_ids.present?
      SharedList.find(:all, :conditions => ["subscriber_list_id IN (?)", self.subscriber_list_ids], :include => :subscriber_list) 
    else
      []
    end
  end
end
