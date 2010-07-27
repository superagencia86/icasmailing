class PasswordResetsController < ApplicationController
  # Method from: http://github.com/binarylogic/authlogic_example/blob/master/app/controllers/application_controller.rb
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Intrucciones para reestablecer la contraseña enviada a tu email."
      redirect_to login_path
    else
      flash[:error] = "No se ha encontrado ningún usuario con la dirección de email #{params[:email]}"
      render :action => :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation= params[:password_confirmation]
    if @user.save
      flash[:notice] = "Su contraseña ha sido actualizada"
      redirect_to login_path
    else
      flash[:error] = "Error al cambiar su contraseña, compruebe que es correcta"
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Lo siento, no podemos localizar tu cuenta"
      redirect_to root_url
    end
  end
end
