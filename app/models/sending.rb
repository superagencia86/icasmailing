class Sending < ActiveRecord::Base
  before_create :add_source_description
  after_create :add_sending_contacts

  belongs_to :campaign
  belongs_to :subscriber_list
  belongs_to :space
  belongs_to :shared_list
  belongs_to :confirmed_space, :class_name => "Space"
  
  has_many :sending_contacts do
    def sent
      self.find(:all, :conditions => {:status => 'sent'})
    end

    def not_sent
      self.find(:all, :conditions => ['status != ?', 'sent'])
    end
  end

  def possible_subscriber_lists
    @possible_subscriber_lists ||= space.subscriber_lists
  end

  def possible_shared_lists
    @possible_shared_lists ||= space.shared_lists
  end

  def possible_spaces; @posible_spaces ||= Space.all ; end

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
  def add_source_description
    if self.source_type == 'list'
      self.source_description = "Envío a todos los contactos de mi lista #{self.subscriber_list.name}"
    elsif self.source_type == 'shared'
      self.source_description = "Envío a todos los contactos confirmados de la lista compartida #{self.shared_list.subscriber_list.name}"
    elsif self.source_type == 'space'
      self.source_description = "Envío a todos los contactos confirmados del espacio #{self.confirmed_space.name}"
    end
  end

  def add_sending_contacts
    status = self.send_duplicates? ? SendingContact::FORCE : SendingContact::PENDING
    if self.source_type == 'list' and self.subscriber_list
      self.subscriber_list.contacts.each {|c| add_sending(c, status)}
    elsif self.source_type == 'shared' and self.shared_list
      self.shared_list.subscriber_list.confirmed_contacts.each {|c| add_sending(c, status)}
    elsif self.source_type = 'space' and self.confirmed_space
      self.confirmed_space.contacts.confirmed.each {|c| add_sending(c, status)}
    end
  end
  
  def add_sending(contact, status)
    SendingContact.create!(:campaign => self.campaign, :sending => self,
      :contact => contact, :status => status, :email => contact.email)
  end

end
