class SendCampaignJob < Struct.new(:campaign_id)
  include ActionView::Helpers::UrlHelper
  
  # Actualizamos una categoría
  def perform
    campaign = Campaign.find(campaign_id)
    emails = []
    campaign.campaign_recipients.valids.each do |recipient|
      if (email = recipient.recipient.email).present? && (emails & [email]).blank?
        options = {}
        if recipient.contact
          options[:confirmation_code] = recipient.contact.confirmation_code
          options[:user_name] = recipient.contact.name
        end
        EmailMailer.queue(:email, campaign, recipient, options)
        emails << email
      end
    end
  end
end
