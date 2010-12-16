ActionController::Routing::Routes.draw do |map|
  map.root                  :controller => 'dashboard'
  map.admin    '/admin',    :controller => 'admin/main'
  map.login    '/login',    :controller => "user_sessions", :action => "new"
  map.logout   '/logout',   :controller => 'user_sessions', :action => 'destroy'
  map.register '/register', :controller => 'users',         :action => 'new'
  map.ajax     '/ajax/:action', :controller => 'ajax',      :action => 'update'
  map.form     '/form',     :controller => 'public',        :action => 'create'
  map.pdf '/pdf', :controller => 'dashboard', :action => 'generate_pdf'
  map.boletin '/boletin', :controller => 'api', :action => 'boletin'

  map.resource  :user_session
  map.resource  :account, :controller => "users"
  map.resources :campaigns, :member => {:subscribers => :any, :selection => :any, :template => :any, :test => :any} do |campaign|
    campaign.resources :email_attachments
  end

  map.namespace :admin do |admin|
    admin.resources :spaces do |space|
      space.resources :users
    end
    admin.resources :users
  end

  map.resources :companies, :collection => {:search => :get}
  map.resources :institution_types
  map.resources :contacts
  map.resources :projects
  map.resources :proposals

  map.resources :comments
  map.resources :password_resets, :only => [ :new, :create, :edit, :update ]

  map.resources :subscriber_lists, :member => { :filter_by_hobbies => :post, :import => :post, :add_all_to => :get, :share => :any, :unshare => :get, :generate_pdf => :get, :generate_excel => :get, :destroy_with_subscribers => :delete} do |subscriber_list|
    subscriber_list.resources :contacts, :collection => {:add_by_type_to => :any, :add_to_list => :any}
  end

  map.admin_jobs '/admin/jobs', :controller => 'admin/jobs', :action => 'index'
  map.admin_mails '/admin/mails', :controller => 'admin/mails', :action => 'index'
  map.connect "#{ConfirmationsController::ACCEPT_URL}/:id/:code", :controller => 'confirmations', :action => 'accept'
  map.connect "#{ConfirmationsController::REJECT_URL}/:id/:code", :controller => 'confirmations', :action => 'reject'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Translator.i18n('es')
ActionController::Routing::Translator.translate_from_file('config','i18n-routes.yml')
