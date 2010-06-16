class DashboardController < ApplicationController
  before_filter :require_user

  def index
    @activities = Activity.find(:all, :include => [:user], :order => 'created_at desc', 
      :conditions => ["user_id IN (#{current_space.user_ids.join(', ')})"], :limit => 20)
  end
end
