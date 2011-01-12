class Admin::CampaignsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    @campaigns = Campaign.all
  end
end
