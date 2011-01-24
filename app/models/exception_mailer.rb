require 'action_mailer'

class ExceptionMailer < ActionMailer::Base
  def setup_mail
    @from = ExceptionNotification::Notifier.sender_address
    @sent_on = Time.now
    @content_type = "text/plain"
  end

  def exception_message(subject, message)
    setup_mail
    @subject = subject
    @recipients = ExceptionNotification::Notifier.exception_recipients
    @body = message
  end
end