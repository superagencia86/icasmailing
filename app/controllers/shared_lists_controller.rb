class SharedListsController < InheritedResources::Base
  before_filter :require_user

  def show
    paginate_options ||= {}
    paginate_options[:page] ||= (params[:page] || 1)
    paginate_options[:per_page] ||= (params[:per_page] || 40)

    @shared_list = SharedList.find params[:id]
    @subscriber_list = @shared_list.subscriber_list
    @contacts = @subscriber_list.confirmed_contacts.paginate(paginate_options)
    show!
  end

  def new
    @source_list = current_space.subscriber_lists.find(params[:list]) if params[:list]
    @shared_list = SharedList.new(:subscriber_list_id => params[:list])
    new!
  end

  def destroy
    @shared_list = SharedList.find params[:id]
    @subscriber_list = current_space.subscriber_lists.find @shared_list.subscriber_list_id
    destroy!(:notice => "La lista '#{@subscriber_list.name}' ya no se comparte con #{@shared_list.space.name}") { subscriber_list_path @subscriber_list}
  end

  def create
    @shared_list = SharedList.new params[:shared_list]
    create!(:notice => "Lista '#{@shared_list.subscriber_list.name}' compartida con #{@shared_list.space.name}") {subscriber_list_path @shared_list.subscriber_list}
  end

end
