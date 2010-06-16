class Admin::SpacesController < ApplicationController
  layout 'admin/application'
  
  before_filter :require_user
  before_filter :load_space, :only => [:edit, :update]
  before_filter :require_admin
  
  def new;   @space   = Space.new; end
  def index; @spaces  = Space.all; end
  def show;  @space   = Space.find_by_permalink(params[:id]); end
  
  def create
    @space = Space.new(params[:space])

    if (can = can?(:create, @space)) && @space.save
      flash[:notice] = t(:space_created, @space.name)
      redirect_back_or_default admin_space_path(@space)
    else
      flash.now[:error] = !can ? t(:insufficent_privileges) : t(:errors_on_form)
      render :action => :new
    end
  end
  
  def update
    if @space.update_attributes(params[:space])
      flash[:notice] = t(:space_updated, @space.name)
      redirect_to admin_space_path(@space)
    else
      flash.now[:error] = t(:errors_on_form)
      render :action => :edit
    end
  end

  def destroy
    @space = Space.find_by_permalink(params[:id])

    if can?(:destroy, @space)
      @space.destroy
      flash[:notice] = t(:space_destroyed, @space.name)
    else
      flash[:error] = t(:something_wrong)
    end

    redirect_to admin_spaces_path
  end

  protected

  def load_space
    @space = (params[:id] && can?(:manage, space = Space.find_by_permalink(params[:id]))) ? space : @current_space
  end

  def require_admin
    return if current_user.is_superadmin? 
    flash[:error] = t(:insufficent_privileges)
    redirect_to root_path
  end
end
