
class SendingJob < Struct.new(:sending_id)
  include ActionView::Helpers::UrlHelper

  LIMIT = 1

  def perform
    begin
      logger = ActiveRecord::Base.logger
      logger.debug "**** job ** Sending ID #{sending_id}"
      sending = Sending.find(sending_id)
      campaign = sending.campaign
      sending.update_attribute(:sent_starts_at, Time.now)
      Activity.report(User.find(1), :send_campaign_starts, campaign)
      logger.debug "**** job ** Campaña: #{campaign.name}"


      total = sending.remaining_contacts_count
      to_send = sending.remaining_contacts(LIMIT)

      logger.debug "**** job ** SENDING JOB TOTAL #{total}"
      logger.debug "**** job ** SENDING JOB TO_SEND #{to_send.size}"

      to_send.each do |sc|
        if sc.pending?
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

      if total > 0
        logger.debug "**** job ** RESEND JOB"
        Delayed::Job.enqueue(SendingJob.new(sending_id))
      else
        logger.debug "**** job ** FINISH JOB"
        sending.update_attributes({:sent_at => Time.now, :current_state => 'sent'})
        Activity.report(User.find(1), :send_campaign_ends, campaign)
      end

      logger.flush

    rescue Exception => e
      ExceptionMailer.deliver_exception_message("[icasmailing] Error en SendingJob", e.to_s)
    end
  end
end
