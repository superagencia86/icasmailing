class ListImportsController < ApplicationController
  before_filter :require_user
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
    elsif params[:import_contact]
      contacts  = []
      not_valid = []
      count     = 0
      params[:contacts].each { |attr| contacts << Contact.new(attr) }
      params[:import_contact].each_key do |key|
        contact = contacts[key.to_i]
        if contact.save
          contact.confirm if params[:confirm] == 'yes'
          @list.contacts << contact
          count += 1
        else
          not_valid << contact
        end
      end
      flash[:notice] = "Se han importado #{count} contactos a la lista #{@list.name}"
    else
      flash[:notice] = "No se ha añadido ningún contacto a la lista #{@list.name}"
    end
    redirect_to @list
  end

  def preview
    @subscriber_list = current_space.subscriber_lists.find params[:subscriber_list_id]
    if params[:list_id] # importamos de una lista
      list      = current_space.subscriber_lists.find params[:list_id]
      @contacts = list.contacts
    elsif params[:subscriber_list] # usamos un filtro
      params[:subscriber_list][:space_id] = current_space.id
      filter                              = ContactFilter.new(SubscriberList.new(params[:subscriber_list]))
      @contacts                           = filter.contacts
    elsif params[:search]
      @contacts = Contact.finder(:space => current_space, :query => params[:search])
    elsif params[:excel]
      @to_add, @duplicated, @errors = ContactsExcel.import(params[:excel], current_user)
      @confirm = params[:confirm].present? ? 'yes' :'no'
      render :action => 'preview_excel'
    else
      @contacts = []
    end
  end

  protected
  def load_list
    @list = current_space.subscriber_lists.find params[:subscriber_list_id]
  end
end
