ActionController::Routing::Routes.draw do |map|
  map.root                  :controller => 'dashboard'
  map.admin    '/admin',    :controller => 'admin/dashboard'
  map.login    '/login',    :controller => "user_sessions", :action => "new"
  map.logout   '/logout',   :controller => 'user_sessions', :action => 'destroy'
  map.register '/register', :controller => 'users',         :action => 'new'
  map.ajax     '/ajax/:action', :controller => 'ajax',      :action => 'update'
  map.form     '/form',     :controller => 'public',        :action => 'create'
  map.pdf '/pdf', :controller => 'dashboard', :action => 'generate_pdf'
  map.boletin '/boletin', :controller => 'api', :action => 'boletin'

  # PUBLIC
  map.resource  :user_session
  map.resource  :account, :controller => "users"
  map.resources :campaigns, :collection => {:search => :get} do |campaign|
    campaign.resources :email_attachments
    campaign.resources :sendings, :as => 'envios', 
      :collection => {:test => :post}
    campaign.resources :sending_contacts, :as => 'contactos',
      :collection => {:search => :get}
  end
  map.resources :companies, :collection => {:search => :get}
  map.resources :institution_types
  map.resources :contacts, :as => 'contactos', :member => {:delete => :get},
    :collection => {:search => :get} do |contact|
    contact.resource :contact_list, :as => 'listas'
  end
  map.resources :projects
  map.resources :proposals
  map.resources :subscriber_lists, :collection => {:search => :get}, :as => 'listas' do |list|
    list.resources :list_subscribers, :as => 'contactos'
    list.resources :list_shared_lists, :as => 'compartidas'
    list.resource :list_export, :as => 'exportar'
    list.resource :list_import, :as => 'importar', :member => {:preview => :post}
  end

  map.resources :comments
  map.resources :password_resets, :only => [ :new, :create, :edit, :update ]


  # ADMIN
  map.namespace :admin do |admin|
    admin.resources :spaces do |space|
      space.resources :users
      space.resources :space_contacts, :as => 'contactos'
      space.resources :space_subscriber_lists, :as => 'listas'
    end
    admin.resources :jobs
    admin.resources :users
    admin.resources :contacts, :as => 'contactos', :collection => {:search => :get}
    admin.resources :subscriber_lists, :as => 'listas'
    admin.resources :campaigns, :as => 'campanyas' do |campaign|
      campaign.resources :sendings, :as => 'envios'
    end
  end



  # #map.resources :subscriber_lists, :member => { :filter_by_hobbies => :post, :import => :post, :add_all_to => :get, :share => :any, :unshare => :get, :generate_pdf => :get, :generate_excel => :get,
  # :destroy_with_subscribers => :delete} do |subscriber_list|
  #  subscriber_list.resources :contacts, :collection => {:add_by_type_to => :any, :add_to_list => :any}
  # #end

  map.connect "#{ConfirmationsController::ACCEPT_URL}/:id/:code", :controller => 'confirmations', :action => 'accept'
  map.connect "#{ConfirmationsController::REJECT_URL}/:id/:code", :controller => 'confirmations', :action => 'reject'

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Translator.i18n('es')
ActionController::Routing::Translator.translate_from_file('config','i18n-routes.yml')
