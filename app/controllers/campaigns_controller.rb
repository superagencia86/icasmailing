class CampaignsController < InheritedResources::Base
  before_filter :require_user, :authorized
  actions :all
  respond_to :html


  def index
    @search_path = search_campaigns_path
    index!
  end

  def search
    @campaigns = current_space.campaigns.find(:all, :conditions =>
        "name LIKE '%#{params[:query]}%'", :limit => 30)
  end

  def create
    data = params[:campaign]
    @campaign = current_space.campaigns.build(:name => data[:name], :subject => data[:subject], :from => data[:from])
    if @campaign.save
      @campaign.update_attributes(data)
      @campaign.save
    end
    create! do |success, failure|
      success.html do
        @campaign.email_attachments.create(:data => params[:new_attachment]) if params[:new_attachment]
        redirect_to @campaign
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        @campaign.email_attachments.create(:data => params[:new_attachment]) if params[:new_attachment]
        redirect_to @campaign
      end
    end
  end


  protected
  def authorized
    unauthorized! if params[:id] && cannot?(:manage, resource)
  end

  def begin_of_association_chain
    current_space
  end
    
  def collection
    paginate_options ||= {}
    paginate_options[:page] ||= (params[:page] || 1)
    paginate_options[:per_page] ||= (params[:per_page] || 20)
    @campaigns ||= end_of_association_chain.paginate(paginate_options)
  end

end
