class AjaxController < ApplicationController
  before_filter :require_user

  def update
    object = eval(CGI.unescape(params[:klass])).find(params[:id])
    send(params[:to_action], object, params[:check])
  end

  protected
  def update_admin(object, check)
    user = UserSession.find.user
    if user.is_admin? || user.is_superadmin?
      if eval(check)
        object.roles -= ["admin"]
      else
        object.roles += ["admin"]
      end
    end

    object.save!
    render :nothing => true
  end
end
