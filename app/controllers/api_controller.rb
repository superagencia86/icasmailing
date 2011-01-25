class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def boletin
    # Find or create a subscriber list for icas boletin
    cicas = Space.confirmed
    user = cicas.users.first
    data = params[:contact].merge({:space_id => cicas.id, :user_id => user.id})
    list = SubscriberList.find_or_create_by_name_and_space_id(:name => "ICAS Boletín", :space_id => cicas, :user_id => user)

    # update or create the contact
    contact = cicas.contacts.find_by_email(params[:email])
    if contact
      contact.update_attributes(data)
    else
      contact = Contact.new(data)
    end
    
    # Create contact and assign to subscriber list
    contact.subscriber_lists << list if contact.save
    contact.confirm
    url = params[:url_callback] || 'http://www.icas-sevilla.org/spip.php?article3651'
    redirect_to url
  end

end
