class Sending < ActiveRecord::Base
  after_create :add_sending_contacts

  belongs_to :campaign
  belongs_to :subscriber_list
  has_many :sending_contacts do
    def sent
      self.find(:all, :conditions => {:status => 'sent'})
    end
  end


  def contacts_count
    SendingContact.count(:all, :conditions => {:sending_id => self.id})
  end

  def sent_count
    SendingContact.count(:all, :conditions => {:sending_id => self.id, :status => SendingContact::DELIVERED})
  end

  def pending_count
    SendingContact.count(:all, :conditions => {:sending_id => self.id, :status => SendingContact::PENDING})
  end
  def duplicated_count
    SendingContact.count(:all, :conditions => {:sending_id => self.id, :status => SendingContact::DUPLICATED})
  end

  protected
  def add_sending_contacts
    if self.subscriber_list
      status = self.send_duplicates? ? SendingContact::FORCE : SendingContact::PENDING
      self.subscriber_list.contacts.each do |contact|
        SendingContact.create!(:campaign => self.campaign, :sending => self,
            :contact => contact, :status => status, :email => contact.email)
      end
    end
  end

end
