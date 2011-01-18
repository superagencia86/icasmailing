class SendingsController < InheritedResources::Base
  before_filter :require_user, :authorized
  belongs_to :campaign

  actions :index, :new, :create, :show

  def index
    @campaign = Campaign.find params[:campaign_id]
    @sending_contacts = @campaign.sending_contacts.paginate(
      :page => params[:page], :per_page => params[:per_page])
  end

  def test
    campaign = Campaign.find params[:campaign_id]
    if params[:email]
      email = params[:email]
      name = email.split('@')[0]
      EmailMailer.deliver_email!(campaign, email, name, '#') 
      flash[:notice] = "Email de prueba enviado!"
    end
    redirect_to campaign
  end

  def create
    create!(:notice => 'Envío en marcha.') do
      Delayed::Job.enqueue(SendingJob.new(@sending.id))
      Activity.report(current_user, :sent, @campaign)
      @campaign
    end
  end


  protected
  def begin_of_association_chain
    current_space
  end

  def authorized
    unauthorized! if params[:id] && cannot?(:manage, resource)
  end
end
