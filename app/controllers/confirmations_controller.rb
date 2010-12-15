class ConfirmationsController < ApplicationController
  before_filter :load_contact

  ACCEPT_URL = "/lista-icas/confirmar"
  REJECT_URL = "/lista-icas/rechazar"

  def accept
    @contact.update_attribute(:confirmed, true)
    render :action => 'show'
  end

  def reject
    @contact.update_attribute(:confirmed, false)
    render :action => 'show'
  end

  protected
  def load_contact
    hex = Digest::MD5.hexdigest(params[:id])
    id = hex == params[:code] ? params[:id] : -1
    @contact = Contact.find id
  end
end
