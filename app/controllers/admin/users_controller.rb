class Admin::UsersController < Admin::AdminController
  # layout 'admin/application'
  
  before_filter :require_user
  before_filter :load_space, :require_admin
  before_filter :load_user, :only => [:edit, :update]
  
  def new;   @user   = User.new; end
  
  def index
    if current_user.is_superadmin?
      @users = User.find(:all, :conditions => 'space_id IS NOT NULL').group_by(&:space_id)
      render "index_admin" and return
    else
      @users = current_space.users
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.space = current_space unless params[:user][:space_id].present?
    if (can = can?(:create, @user)) && @user.save
      flash[:notice] = t(:user_created, @user.name)
      redirect_back_or_default admin_space_users_path(@space)
    else
      flash.now[:error] = !can ? t(:insufficent_privileges) : t(:errors_on_form)
      render :action => :new
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:user_updated, @user.name)
      redirect_to admin_space_users_path(@space)
    else
      flash.now[:error] = t(:errors_on_form)
      render :action => :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if can?(:destroy, @user)
      @user.destroy
      flash[:notice] = t(:user_destroyed, @user.name)
    else
      flash[:error] =  t(:something_wrong)
    end

    redirect_to admin_space_users_path(@space)
  end

  protected

  def load_user
    if current_user.is_superadmin?
      @user = (params[:id] && can?(:manage, user = User.find(params[:id]))) ? user : @current_user
    else
      @user = (params[:id] && can?(:manage, user = @space.users.find(params[:id]))) ? user : @current_user
    end
  end

  def require_admin
    return if current_user.is_superadmin? || current_user.is_users_manager?
    flash[:error] = t(:insufficent_privileges)
    redirect_to root_path
  end
end
