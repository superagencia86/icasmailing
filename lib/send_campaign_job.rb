class SendCampaignJob < Struct.new(:campaign_id)
  include ActionView::Helpers::UrlHelper
  
  # Actualizamos una categoría
  def perform
    campaign = Campaign.find(campaign_id)
    emails = []
    campaign.campaign_recipients.valids.each do |recipient|
      if (email = recipient.recipient.email).present? && (emails & [email]).blank?
        contact = recipient.contact
        if contact
          # EmailMailer.queue(:email, campaign, recipient, contact.name, contact.confirmation_code)
          EmailMailer.deliver_email!(campaign, recipient, contact.name, contact.confirmation_code)
        else
          # EmailMailer.queue(:email, campaign, recipient, '', '#')
          EmailMailer.deliver_email!(campaign, recipient, '', '#')
        end
        emails << email
      end
    end
  end
end
