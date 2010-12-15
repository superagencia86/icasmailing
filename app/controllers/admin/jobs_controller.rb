class Admin::JobsController < Admin::AdminController
  before_filter :require_user, :require_admin

  def index
    @jobs = DelayedJob.all
  end

  def destroy
    @job = DelayedJob.find params[:id]
    @job.destroy
    redirect_to jobs_path
  end
end
