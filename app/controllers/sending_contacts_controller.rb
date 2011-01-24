class SendingContactsController < ApplicationController
  def index
    @campaign = Campaign.find params[:campaign_id]
    #@search_path = search_campaign_sendings_path(@campaign)
    @sending_contacts = @campaign.sending_contacts.paginate(
      :page => params[:page], :per_page => params[:per_page])

  end

  def search
    @campaign = Campaign.find params[:campaign_id]
    @sendings_contacts = @campaign.sending_contacts.find(:all, :conditions =>
        "email LIKE '%#{params[:query]}%'", :limit => 30)
  end
end