class ListSubscribersController < InheritedResources::Base
  before_filter :require_user, :load_space
  belongs_to :subscriber_list
  defaults :resource_class => Subscriber, :collection_name => 'subscribers', :instance_name => 'subscriber'
  actions :index, :create, :destroy
  belongs_to :subscriber_list


  def destroy
    destroy! { subscriber_list_list_subscribers_path(@subscriber_list) }
  end

  protected
  def begin_of_association_chain
    current_space
  end
end
