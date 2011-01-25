class Admin::RolesController < Admin::AdminController
  before_filter :require_user
  before_filter :load_space, :require_admin

  def update
    @user = User.find params[:user_id]
    role = params[:rol]
    translate = t("roles.#{role}")
    if current_user.is_admin? || current_user.is_superadmin?
      if @user.has_role?(role)
        @user.remove_role!(role)
        @msg = "#{@user.full_name} ya no puede #{translate}"
      else
        @user.add_role!(role)
        @msg = "#{@user.full_name} puede #{translate}"
      end
    else
      @msg = "No tienes suficientes privilegios"
    end
  end

end
