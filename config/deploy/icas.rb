set :application, "icasmailing"
set :domain, "superagencia86.com"
server domain, :app, :web
role :db, domain, :primary => true
set :deploy_to, "/var/www/superage/#{application}"
set :rails_env, 'production'
