class Admin::SubscriberListsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    @lists = SubscriberList.all(:order => 'id DESC')
  end
end
