class SendingContact < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :sending
  belongs_to :contact

  validates_presence_of :campaign, :sending, :contact

  def delivered!
    self.update_attribute(:status, 'delivered')
  end

  def state?(state)
    return self.state == state.to_s
  end
end
