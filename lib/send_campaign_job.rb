class SendCampaignJob < Struct.new(:campaign_id)
  include ActionView::Helpers::UrlHelper
  
  # Actualizamos una categoría
  def perform
    campaign = Campaign.find(campaign_id)
    emails = []
    campaign.campaign_recipients.valids.each do |recipient|
      if (email = recipient.recipient.email).present? && (emails & [email]).blank?
        code = recipient.contact ? recipient.contact.confirmation_code : nil
        EmailMailer.queue(:email, campaign, recipient, {:confirmation_code => code})
        emails << email
      end
    end
  end
end
