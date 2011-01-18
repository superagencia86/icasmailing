class Admin::SpaceSubscriberListsController < Admin::AdminController
  before_filter :require_user
  before_filter :require_admin

  def index
    @space = Space.find_by_permalink(params[:space_id])
    @lists = @space.subscriber_lists
  end

end
