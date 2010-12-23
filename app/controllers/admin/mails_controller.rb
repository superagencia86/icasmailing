class Admin::MailsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    @mails = Mail.all
  end


  def destroy
    @mail = Mail.find params[:id]
    @mail.destroy
    redirect_to admin_mails_path
  end
end
