class Admin::DashboardController < Admin::AdminController
  before_filter :require_user, :require_admin

end
