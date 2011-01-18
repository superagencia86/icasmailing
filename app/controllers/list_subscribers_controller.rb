class ListSubscribersController < InheritedResources::Base
  before_filter :require_user, :load_space
  belongs_to :subscriber_list
  defaults :resource_class => Subscriber, :collection_name => 'subscribers', :instance_name => 'subscriber'
  actions :index, :create, :destroy
  belongs_to :subscriber_list

  def index
    paginate_options ||= {}
    paginate_options[:page] ||= (params[:page] || 1)
    paginate_options[:per_page] ||= (params[:per_page] || 40)

    @subscriber_list = SubscriberList.find params[:subscriber_list_id]
    if @subscriber_list.auto_update?
      @contacts = @subscriber_list.contacts.paginate(paginate_options)
    else
      @subscribers = @subscriber_list.subscribers.paginate(paginate_options)
    end
  end

    def destroy
      destroy! { subscriber_list_list_subscribers_path(@subscriber_list) }
    end

    protected
    def begin_of_association_chain
      current_space
    end
  end
