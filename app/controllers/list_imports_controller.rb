class ListImportsController < ApplicationController
  before_filter :load_list

  def new
    @subscriber_list = SubscriberList.new # used for filter
  end

  def create
    if params[:contact_ids].present?
      @contacts = Contact.find params[:contact_ids]
      @list.contacts << @contacts
      @list.save
      flash[:notice] = "#{@contacts.size} añadidos a la lista #{@list.name}"
    else
      flash[:notice] = "No se ha añadido ningún contacto a la lista #{@list.name}"
    end
    redirect_to @list
  end

  def preview
    if params[:list_id] # importamos de una lista
      list = current_space.subscriber_lists.find params[:list_id]
      @contacts = list.contacts
    elsif params[:subscriber_list] # usamos un filtro
      params[:subscriber_list][:space_id] = current_space.id
      filter = ContactFilter.new(SubscriberList.new(params[:subscriber_list]))
      @contacts = filter.contacts
    else
      @contacts = []
    end
  end
  
  protected
  def load_list
    @list = current_space.subscriber_lists.find params[:subscriber_list_id]
  end
end
