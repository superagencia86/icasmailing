class ContactListsController < ApplicationController
  before_filter :require_user, :load_space

  def edit
    @contact = current_space.contacts.find params[:contact_id]
    @lists = current_space.subscriber_lists.normal
  end

end
