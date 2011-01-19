class SubscriberListsController < InheritedResources::Base
  before_filter :require_user

  def index
    @search_path = search_subscriber_lists_path
    index!
  end

  def new
    params[:subscriber_list] ||= {}
    params[:subscriber_list][:auto_update] = params[:auto_update]
    params[:subscriber_list][:user_id] = current_user.id
    new!
  end

  def search
    @subscriber_lists = current_space.subscriber_lists.find(:all, :conditions =>
        "name LIKE '%#{params[:query]}%'", :limit => 30)
  end

  protected
  def begin_of_association_chain
    current_space
  end
end
