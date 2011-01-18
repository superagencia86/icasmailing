class SendingContact < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :sending
  belongs_to :contact

  validates_presence_of :campaign, :sending, :contact

  PENDING = 'pending'
  DELIVERED = 'sent'
  DUPLICATED = 'duplicated'
  FORCE = 'force'

  def duplicated!
    self.update_attribute(:status, DUPLICATED)
  end

  def delivered!
    self.update_attribute(:status, DELIVERED)
  end

  def pending?
    self.status == PENDING || self.status == FORCE
  end
end
