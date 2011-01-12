class CampaignsController < InheritedResources::Base
  before_filter :require_user, :authorized
  actions :all
  respond_to :html


  def create
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
