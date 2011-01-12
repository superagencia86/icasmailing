class Admin::SendingsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    @campaign = Campaign.find params[:campaign_id]
    @sendings = @campaign.sendings
  end
end
