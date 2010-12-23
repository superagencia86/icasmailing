# Base class for admin controllers

class Admin::AdminController < ApplicationController
  protected
  def require_admin
    return if current_user.is_superadmin? || current_user.is_admin?
    flash[:error] = t(:insufficent_privileges)
    redirect_to root_path
  end
end
