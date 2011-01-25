class SharedListContactsController < ApplicationController

  def show
    @shared_list = current_space.shared_lists.find params[:shared_list_id]
    @subscriber_list = @shared_list.subscriber_list
    @contact = @subscriber_list.contacts.find params[:id]
  end
end
