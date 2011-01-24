class Admin::DashboardController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    
  end

  def send_error
    ExceptionMailer.deliver_exception_message("Error generado", "Nombre del error")
    redirect_to admin_path
  end
end
