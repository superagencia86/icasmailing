
class SendCampaignJob < Struct.new(:campaign_id)
  include ActionView::Helpers::UrlHelper
  
  # Actualizamos una categoría
  def perform
    logger = ActiveRecord::Base.logger
    logger.debug "PERFORM SendCampaignJob"
    logger.debug "CAMPAIGN ID #{campaign_id}"
    campaign = Campaign.find(campaign_id)
    emails = []
    logger.debug "CAMPAIGN #{campaign.to_yaml}"
    campaign.campaign_recipients.valids.each do |recipient|
      logger.debug "RECIPIENT: #{recipient.to_yaml}"
      if (email = recipient.recipient.email).present? && (emails & [email]).blank?
        contact = recipient.contact
        logger.debug "CONTACT: #{contact.to_yaml}"
        if contact
          # EmailMailer.queue(:email, campaign, recipient, contact.name, contact.confirmation_code)
          EmailMailer.deliver_email!(campaign, recipient, contact.name, contact.confirmation_code)
        else
          # EmailMailer.queue(:email, campaign, recipient, '', '#')
          EmailMailer.deliver_email!(campaign, recipient, '', '#')
        end
        sleep 0.1
        emails << email
      end
    end
  end
end
