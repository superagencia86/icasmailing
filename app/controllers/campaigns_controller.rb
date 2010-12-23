class CampaignsController < InheritedResources::Base
  before_filter :require_user, :authorized
  actions :all
  respond_to :html

  def create
    create! do |success, failure|
      success.html { 
        save_or_go_to(subscribers_campaign_path(@campaign))
      }
    end
  end

  def update
    update! do |success, failure|
      success.html { 
        save_or_go_to(subscribers_campaign_path(@campaign))
      }
    end
  end

  def subscribers
    @subscriber_lists = current_space.subscriber_lists

    unless request.get?
      params[:campaign] ||= {}
      params[:campaign][:subscriber_list_ids] ||= []

      if params[:campaign][:subscriber_list_ids].length > 0
        @campaign.subscriber_list_ids = current_space.valid_subscriber_lists(params[:campaign][:subscriber_list_ids])
        @campaign.save
        save_or_go_to(selection_campaign_path(@campaign))
      else 
        flash.now[:error] = "Debe seleccionar al menos una lista de subscriptores"
        render :action => :subscribers
      end
    end
  end

  def selection
    @campaign_recipients = @campaign.campaign_recipients
    
    unless request.get?
      params[:campaign_recipient_ids] ||= [] 
      
      # Set active attribute
      if params[:campaign_recipient_ids].present?
        @campaign.campaign_recipients.update_all({:active => false}, "active = 1 AND recipient_id NOT IN (#{params[:campaign_recipient_ids].join(', ')})")

        @campaign.campaign_recipients.update_all({:active => true}, "active = 0 AND recipient_id IN (#{params[:campaign_recipient_ids].join(', ')})")
      end
      # for campaign_recipient in @campaign.campaign_recipients
      #   if campaign_recipient.active && !params[:campaign_recipient_ids].include?(campaign_recipient.recipient_id.to_s)
      #     campaign_recipient.update_attribute(:active, false)
      #   elsif !campaign_recipient.active && params[:campaign_recipient_ids].include?(campaign_recipient.recipient_id.to_s)
      #     campaign_recipient.update_attribute(:active, true)
      #   end
      # end
      
      save_or_go_to(template_campaign_path(@campaign))
    end
  end

  def template
    unless request.get?
      if (@campaign.assets.html.present? || params[:campaign][:asset_html].present?) || params[:campaign][:body].present?
        @campaign.update_attributes(params[:campaign])
        save_or_go_to(test_campaign_path(@campaign))
      else
        flash.now[:error] = "Debes añadir un HTML"
        redirect_to :action => :template
      end
    end    
  end

  def test
    if params[:test].present?
      email = params[:receivers]
      name = email.split('@')[0]
      EmailMailer.deliver_email!(@campaign, email, name, '#') if params[:receivers]
      flash[:notice] = "Email de prueba enviado!"
    elsif params[:send].present?
      Delayed::Job.enqueue(SendCampaignJob.new(@campaign.id))
      Activity.report(current_user, :sent, @campaign)

      flash[:notice] = "Campaña tramitada a envío"
      redirect_to campaigns_path
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

  def save_or_go_to(path)
    if params[:commit] =~ /^Guardar$/
      redirect_to campaigns_path
    else
      redirect_to path
    end
  end
end
