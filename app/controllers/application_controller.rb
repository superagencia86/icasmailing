# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_locale_from_url
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_space, :current_user, :logged_in?
  include ExceptionNotification::Notifiable

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private
    def logged_in?
      !!current_user
    end

    def load_space
      @space ||= Space.find_by_permalink(params[:space_id])
      @space = current_space if @space.nil?
    end

    def current_space
      @current_space ||= current_user.space if current_user
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "Debes estar logueado para acceder a esta página"
        redirect_to login_path
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        redirect_to root_url
        return false
      end
    end
    

    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def load_subscription_list_conditions
      conditions = ["contacts.space_id = #{current_space.id}"]
      if params[:filter]
        if params[:filter][:contact_type].present?
          conditions << "contact_type_id = #{params[:filter][:contact_type]}"
          case(params[:filter][:contact_type])
          when('1') # general
            conditions << "hobbies.id = #{params[:filter][:contact_type_hobby]}" if params[:filter][:contact_type_hobby].present?
          when('4') # instituciones
            conditions << "institution_type_id = #{params[:filter][:contact_type_institution_type]}" if params[:filter][:contact_type_institution_type].present?
          end
        end

        if params[:filter][:query].present?
          conditions << "(contacts.email LIKE '%#{params[:filter][:query]}%' OR contacts.name LIKE '%#{params[:filter][:query]}%')"
        end
        
        if params[:filter][:active] == 'false'
          conditions << "((subscribers.active = 0 AND subscribers.subscriber_list_id = ?) OR (subscribers.subscriber_list_id IS NULL OR subscribers.subscriber_list_id != ?))"
        end
      end
      conditions.join(" AND ")
    end
end
