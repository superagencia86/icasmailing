class ContactEmailsController < ApplicationController
  before_filter :require_user, :load_space

  def edit
    @contact = current_space.contacts.find params[:contact_id]
  end

  def update
    @contact = current_space.contacts.find params[:contact_id]
    original_email = @contact.email
    if params[:email].present?
      new_email = params[:email]
      if original_email != new_email
        Contact.find_all_by_email(original_email).each do |contact|
          contact.update_attribute(:email, params[:email])
        end
        flash[:notice] = "Hemos cambiado el email de #{original_email} a #{params[:email]}"
      end
    end
    redirect_to @contact
  end
end
