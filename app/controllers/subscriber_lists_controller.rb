class SubscriberListsController < InheritedResources::Base
  before_filter :require_user

  def index
    @search_path = search_subscriber_lists_path
    index!
  end

  def new
    params[:auto_update] ||= false
    params[:subscriber_list] ||= {}
    params[:subscriber_list][:auto_update] = params[:auto_update]
    params[:subscriber_list][:user_id] = current_user.id
    @subscriber_list = current_space.subscriber_lists.build(params[:subscriber_list])
    if params[:clone]
      @source_list = current_space.subscriber_lists.find params[:clone]
      @subscriber_list.clone_list_id = params[:clone]
    end
    new!
  end

  def create
    params[:subscriber_list][:auto_update] ||= false
    create!
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
