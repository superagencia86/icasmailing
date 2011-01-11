class Admin::ContactsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    page =  params[:page] || 1
    per_page = params[:per_page] || 100
    @contacts = Contact.paginate(:page => page, :per_page => per_page, :order => 'id DESC')
  end

end
