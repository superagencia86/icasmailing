class Admin::JobsController < Admin::AdminController
  before_filter :require_user, :require_admin


  def show
    job = DelayedJob.find params[:id]
    job.update_attributes(:attempts => 0, :last_error => '')
    redirect_to admin_jobs_path
  end

  def index
    @jobs = DelayedJob.all
  end

  def destroy
    @job = DelayedJob.find params[:id]
    @job.destroy
    redirect_to admin_jobs_path
  end
end
