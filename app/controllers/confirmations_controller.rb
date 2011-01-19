class ConfirmationsController < ApplicationController
  
  before_filter :load_contact

  ACCEPT_URL = "/lista-icas/confirmar"
  REJECT_URL = "/lista-icas/rechazar"

  def accept
    if !@contact.confirmed?
      @contact.confirm
      EmailMailer.queue(:accept_subscription, @contact.email, @contact.name, @contact.confirmation_code)
      Activity.report(User.find(1), :accept_confirmation, @contact)
    end
    redirect_to 'http://www.icas-sevilla.org/spip.php?article3651'
  end

  def reject
    if @contact.confirmed?
      @contact.unconfirm
      EmailMailer.queue(:reject_subscription, @contact.email, @contact.name, @contact.confirmation_code)
      Activity.report(User.find(1), :reject_confirmation, @contact)
    end
    redirect_to 'http://www.icas-sevilla.org/spip.php?article3680'
  end

  protected
  def load_contact
    hex = Digest::MD5.hexdigest(params[:id])
    id = hex == params[:code] ? params[:id] : -1
    @contact = Contact.find id
  end
end
