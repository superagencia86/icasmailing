class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def boletin
    # Find or create a subscriber list for icas boletin
    cicas = Space.confirmed
    user = cicas.users.first
    data = params[:contact].merge({:space_id => cicas.id, :user_id => user.id})
    list = cicas.subscriber_lists.find_by_name('ICAS Boletín')
    list ||= SubscriberList.create!(:name => "ICAS Boletín", :space_id => cicas.id, :user_id => user)

    # update or create the contact
    contact = cicas.contacts.find_by_email(data[:email])
    if contact
      data.delete :email
      contact.update_attributes(data)
    else
      contact = Contact.new(data)
      contact.save
    end
    
    # Create contact and assign to subscriber list
    if !list.subscribers.find_by_contact_id(contact.id)
      list.contacts << contact
      list.save
    end

    contact.confirm
    url = params[:redirect_url] || 'http://www.icas-sevilla.org/spip.php?article3651'
    redirect_to url
  end

end
