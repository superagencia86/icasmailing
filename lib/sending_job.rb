
class SendingJob < Struct.new(:sending_id)
  include ActionView::Helpers::UrlHelper

  # Actualizamos una categoría
  def perform
    logger = ActiveRecord::Base.logger
    logger.debug "Sending ID #{sending_id}"
    sending = Sending.find(sending_id)
    campaign = sending.campaign
    sending.update_attribute(:sent_starts_at, Time.now)
    Activity.report(User.find(1), :send_campaign_starts, campaign)
    logger.debug "Campaña: #{campaign.name}"
    
    sending.sending_contacts.each do |sending_contact|
      if sending_contact.state? :pending
        email = sending_contact.email
        contact = sending_contact.contact
        EmailMailer.deliver_email!(campaign, email, contact.name, contact.confirmation_code)
        sending_contact.delivered!
        sleep 0.1
      end
    end
    sending.update_attribute(:sent_at, Time.now)
    Activity.report(User.find(1), :send_campaign_ends, campaign)
  end
end
