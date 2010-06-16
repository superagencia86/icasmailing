class CampaignRecipient < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :recipient, :polymorphic => true
  
  belongs_to :subscriber, :class_name => "Subscriber", :foreign_key => 'recipient_id'
  belongs_to :company,    :class_name => "Company",    :foreign_key => "recipient_id"
  belongs_to :contact,    :class_name => "Contact",    :foreign_key => "recipient_id"
end
