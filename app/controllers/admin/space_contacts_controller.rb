class Admin::SpaceContactsController < Admin::AdminController
  before_filter :require_user
  before_filter :require_admin

  def index
    @space = Space.find_by_permalink(params[:space_id])
    @contacts = @space.contacts.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'id DESC')
  end

end
