class DashboardController < ApplicationController
  before_filter :require_user

  def index
    if current_user.is_superadmin?
      @activities = Activity.find(:all, :include => [:user], :order => 'created_at desc', :limit => 50)
    else
      @activities = Activity.find(:all, :include => [:user], :order => 'created_at desc', 
        :conditions => ["user_id IN (#{current_space.user_ids.join(', ')})"], :limit => 20)
    end
  end
  
end
