class ListImportsController < ApplicationController
  before_filter :load_list


  def create
    if params[:contact_ids].present?
      @contacts = Contact.find params[:contact_ids]
      @list.contacts << @contacts
      @list.save
    end
    redirect_to @list
  end

  def preview
    if params[:list_id]
      list = current_space.subscriber_lists.find params[:list_id]
      @contacts = list.contacts
    else
      @contacts = []
    end
  end
  
  protected
  def load_list
    @list = current_space.subscriber_lists.find params[:subscriber_list_id]
  end
end
