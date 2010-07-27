class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    subject      "Información de recuperación de contraseña"
    from         "noresponder@icas-sevilla.org"
    recipients   user.email
    content_type "text/html"
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
