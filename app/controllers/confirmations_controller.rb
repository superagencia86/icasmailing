class ConfirmationsController < ApplicationController
  before_filter :load_contact

  ACCEPT_URL = "/lista-icas/confirmar"
  REJECT_URL = "/lista-icas/rechazar"

  def accept
    if !@contact.confirmed?
      EmailMailer.queue(:accept_subscription, @contact.email, @contact.name, @contact.confirmation_code)
      @contact.update_attribute(:confirmed, true)
    end
    redirect_to 'http://www.icas-sevilla.org/spip.php?article3651'
  end

  def reject
    @contact.update_attribute(:confirmed, false)
    redirect_to 'http://www.icas-sevilla.org/spip.php?article3680'
  end

  protected
  def load_contact
    hex = Digest::MD5.hexdigest(params[:id])
    id = hex == params[:code] ? params[:id] : -1
    @contact = Contact.find id
  end
end
