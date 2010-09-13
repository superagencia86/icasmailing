class SendCampaignJob < Struct.new(:campaign_id)
  # Actualizamos una categoría
  def perform
    campaign = Campaign.find(campaign_id)
    emails = []
    campaign.campaign_recipients.valids.each do |campaign_recipient|
      if (email = campaign_recipient.recipient.email).present? && (emails & [email]).blank?
        EmailMailer.queue(:email, campaign, campaign_recipient)
        emails << email
      end
    end
  end
end
