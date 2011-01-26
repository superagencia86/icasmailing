class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @space = Space.find_by_id(params[:user_session][:space_id])
    @user_session = @space.user_sessions.new(params[:user_session]) if @space
    if @space && @user_session.save
      flash[:notice] = "Bienvenido, #{User.find_by_email(@user_session.email).full_name}!"
      redirect_back_or_default root_url
    else
      @user_session = UserSession.new
      flash.now[:error] = "Existen errores en el formulario de acceso."
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Hasta pronto!"
    redirect_back_or_default login_url
  end
end

