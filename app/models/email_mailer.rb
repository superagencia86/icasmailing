class EmailMailer < ActionMailer::Base
  def accept_subscription(email, name, reject_code)
    subject 'Has decidido conocer toda la Cultura de Sevilla'
    recipients email
    from 'Comunicaciones ICAS <comunicaciones@icasmailing.org>'
    sent_on Time.now
    from 'Comunicaciones ICAS <comunicaciones@icasmailing.org>'
    content_type 'text/html'
    body :name => name, :code => "http://#{APP.host}#{ConfirmationsController::REJECT_URL}/#{reject_code}"
  end

  def reject_subscription(email, name, reject_code)
    subject 'Has decidido dejar de recibir toda la Cultura de Sevilla en tu email'
    recipients email
    from 'Comunicaciones ICAS <comunicaciones@icasmailing.org>'
    sent_on Time.now
    from 'Comunicaciones ICAS <comunicaciones@icasmailing.org>'
    content_type 'text/html'
    body :name => name, :code => "http://#{APP.host}#{ConfirmationsController::ACCEPT_URL}/#{reject_code}"
  end


  def email(campaign, campaign_recipient, name, code, sent_at = Time.now)
    email = campaign_recipient.is_a?(String) ? campaign_recipient : campaign_recipient.recipient.email
    subject    campaign.subject
    recipients email
    from "#{campaign.from_name} <#{campaign.from}>"

    sent_on    sent_at
    reply_to   campaign.reply_to

    if campaign.body.present?
      html = false
      data = campaign.body
    elsif campaign.assets.html
      html = true
      file = campaign.assets.html.data.url.split("?").first
      data = File.read(File.join(Rails.root, "public", file))
      # data.gsub!("<head>", "<head>\n<base href='http://#{APP.host}/campaign/#{campaign.id}/images/' />")
    else
      html = false
      data = ''
    end


    campaign.email_attachments.each do |ea|
      attachment ea.data_content_type do |a| 
        a.body = File.read(File.join(Rails.root, "public", ea.data.url(:original, false)))
        a.filename = ea.data_file_name
      end 
    end

    if data
      subs = {}
      subs['aceptar'] = "http://#{APP.host}#{ConfirmationsController::ACCEPT_URL}/#{code}"
      subs['rechazar'] = "http://#{APP.host}#{ConfirmationsController::REJECT_URL}/#{code}"
      subs['nombre'] = name ? name : ''
      subs.each_pair do |key, value|
        data = data.gsub("{{#{key}}}", value)
      end
    end

    campaign_recipient.update_attribute(:sent_email, true) if !campaign_recipient.is_a?(String)
    body :data => data, :html => html
    content_type 'text/html'
  end
end
