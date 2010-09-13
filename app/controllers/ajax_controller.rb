class AjaxController < ApplicationController
  before_filter :require_user

  def update
    object = eval(CGI.unescape(params[:klass])).find(params[:id])
    send(params[:to_action], object, params[:check], params[:role])
  end

  protected
  def update_role(object, check, role)
    user = UserSession.find.user

    if user.is_admin? || user.is_superadmin?
      object.has_role?(role) ? object.remove_role!(role) : object.add_role!(role)
    end

    # object.save!
    render :nothing => true
  end
end
