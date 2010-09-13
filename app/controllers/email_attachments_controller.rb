class EmailAttachmentsController < ApplicationController
  before_filter :require_user, :load_campaign

  def create
     @campaign.email_attachments.build(params[:email_attachment]) 
     if @campaign.save
      flash[:notice] = "Fichero adjuntado correctamente"
     else
      flash[:error] = "Error al adjuntar el fichero"
     end
     redirect_to :back
  end

  def destroy
    attach = @campaign.email_attachments.find(params[:id]) 
    attach.try(:destroy)
    flash[:notice] = "Fichero eliminado"
    redirect_to :back
  end
  def load_campaign
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end
end
