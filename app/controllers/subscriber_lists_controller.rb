class SubscriberListsController < InheritedResources::Base

  def new
    params[:subscriber_list] ||= {}
    params[:subscriber_list][:auto_update] = false
    new!
  end

  protected
  def begin_of_association_chain
    current_space
  end
end
