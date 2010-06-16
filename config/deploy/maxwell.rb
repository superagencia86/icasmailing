set :application, "maxwell"
set :domain, "maxwell.superagencia86.es"
server domain, :app, :web
role :db, domain, :primary => true
set :deploy_to, "/var/www/superage/#{application}"
set :rails_env, 'production'

