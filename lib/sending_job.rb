
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
    
    sending.sending_contacts.each do |sc|
      if sc.status? :pending
        delivered = SendingContact.find(:first, :conditions => {
            :status => SendingContact::DELIVERED,
            :campaign_id => sc.campaign_id, :email => sc.email})
        
        if delivered and sc.status != SendingContact::FORCE
          sc.duplicated!
        else
          contact = sc.contact
          EmailMailer.deliver_email!(campaign, sc.email, contact.name, contact.confirmation_code)
          sc.delivered!
        end
        sleep 0.1
      end
    end
    sending.update_attributes({:sent_at => Time.now, :current_state => 'sent'})
    Activity.report(User.find(1), :send_campaign_ends, campaign)
  end
end
