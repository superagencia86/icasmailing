class ConfirmationsController < ApplicationController
  before_filter :load_contact

  def show
  end

  def aceptar
    confirm(true)
  end

  def rechazar
    confirm(false)
  end


  protected
  def confirm(state)
    @contact.update_attribute(:confirmed, state)
    redirect_to contact_confirmation_path(@contact)
  end


  def load_contact
    @contact = Contact.find params[:contact_id]
  end
end
