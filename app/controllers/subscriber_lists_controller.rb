class SubscriberListsController < InheritedResources::Base
  protected
  def begin_of_association_chain
    current_space
  end
end
