class SendingsController < InheritedResources::Base
  before_filter :require_user, :authorized
  belongs_to :campaign

  actions :new, :create

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
    create!(:notice => 'Envío realizado!') do
      Delayed::Job.enqueue(SendingJob.new(@sending.id))
      Activity.report(current_user, :sent, @campaign)
      redirect_to campaign_path(@campaign)
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
