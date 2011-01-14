class Admin::SendingsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    @campaign = Campaign.find params[:campaign_id]
    @sendings = @campaign.sendings
  end

  def show
    @campaign = Campaign.find params[:campaign_id]
    @sending = @campaign.sendings.find params[:id]
  end
end
