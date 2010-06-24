class PublicController < ApplicationController
  def create
    message = ''
    message = 'Información incompleta' if [:name, :surname, :email , :subscriber_list_id].detect{|x| params[x].blank? }
    message = 'El email ya existe en esta lista de correos.' if Contact.find_by_email(params[:email]).present?
    if (contact = Contact.find_by_ip(request.remote_ip, :order => 'created_at desc')) && contact.created_at > (Time.now - 1.minutes)
      message = 'Estamos teniendo problemas técnicos. Por favor inténtelo más tarde.' 
    end
    message = 'No existe la lista de correos.' if (subscriber_list = SubscriberList.find_by_id(params[:subscriber_list_id])).nil?
    render :text => message and return if message.present?

    contact = Contact.create(:name => params[:name], :surname => params[:surname], :email => params[:email], :from_form => true, :ip => request.remote_ip)
    Subscriber.find_or_create_by_subscriber_list_id_and_contact_id(subscriber_list.id, contact.id)

    render :text => "Tu subscripción ha sido creada."
  end
end
