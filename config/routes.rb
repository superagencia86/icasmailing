ActionController::Routing::Routes.draw do |map|
  map.root                  :controller => 'dashboard'
  map.admin    '/admin',    :controller => 'admin/main'
  map.login    '/login',    :controller => "user_sessions", :action => "new"
  map.logout   '/logout',   :controller => 'user_sessions', :action => 'destroy'
  map.register '/register', :controller => 'users',         :action => 'new'
  map.ajax     '/ajax/:action', :controller => 'ajax',      :action => 'update'

  map.resource  :user_session
  map.resource  :account, :controller => "users"
  map.resources :campaigns, :member => {:subscribers => :any, :selection => :any, :template => :any, :test => :any}

  map.namespace :admin do |admin|
    admin.resources :spaces do |space|
      space.resources :users
    end
    admin.resources :users
  end

  map.resources :companies, :collection => {:search => :get}
  map.resources :contacts
  map.resources :projects
  map.resources :proposals

  map.resources :comments

  map.resources :subscriber_lists, :member => {:share => :any, :unshare => :get} do |subscriber_list|
    subscriber_list.resources :subscribers, :collection => {:add_multiple => :any}
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Translator.i18n('es')
ActionController::Routing::Translator.translate_from_file('config','i18n-routes.yml')
