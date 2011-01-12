class Sending < ActiveRecord::Base
  belongs_to :campaign
  has_and_belongs_to_many :subscriber_lists

  has_many :campaign_recipients do
    def valids
      self.find(:all, :conditions => ["active is true and sent_email is false and visible is true"])
    end

    def sent
      self.find(:all, :conditions => ["sent_email is true"])
    end
  end

  has_many :subscriber_recipients, :through => :campaign_recipients, :source => :subscriber,
    :conditions => "campaign_recipients.recipient_type = 'Subscriber' AND visible is true"
  has_many :company_recipients, :through => :campaign_recipients, :source => :company,
    :conditions => "campaign_recipients.recipient_type = 'Company' AND visible is true"
  has_many :contact_recipients, :through => :campaign_recipients, :source => :contact,
    :conditions => "campaign_recipients.recipient_type = 'Contact' AND visible is true"

end
