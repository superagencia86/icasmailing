class EmailAttachment < ActiveRecord::Base
  belongs_to :campaign
  validates_presence_of :data_file_name

  Paperclip.interpolates :campaign_id do |attachment, style|
    attachment.instance.campaign.try(:id)
  end

  has_attached_file :data, 
    :path => ":rails_root/public/campaign/:campaign_id/attachments/:basename.:extension",
    :url => "/campaign/:campaign_id/attachments/:basename.:extension"
end
