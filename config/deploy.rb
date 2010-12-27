############################################################
#	Application
#############################################################

require 'erb'

set :application, "icas-mailing"
set :domain, "superagencia86.com"
server domain, :app, :web
role :db, domain, :primary => true
# set :deploy_to, "/home/superage/produccion/#{application}"
set :deploy_to, "/var/www/superage/icasmailing"
set :rails_env, 'production'

#############################################################
#	Settings
#############################################################
 
default_run_options[:pty] = true
set :keep_releases, 2
set :use_sudo, false 

#############################################################
#	Servers
#############################################################

# set :user, "superage" 
set :user, "deploy"
 
#############################################################
#	Git
#############################################################
 
set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :repository,  "git@trunksapp.com:beecoder/icas-maxwell.git"

# before "deploy:stop_mail_daemon"
after "deploy:update_code", "db:symlink" # , "deploy:restart_mail_daemon"
after "deploy:symlink", "deploy:start_mail_cycle"
 
namespace :db do
  desc "Make symlink for database yaml, mongrel cluster"
  task :symlink do     
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"      
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"      
    run "ln -nfs #{shared_path}/public/campaign #{release_path}/public/campaign"
  end
end

namespace :deploy do
  desc "start_mail_cycle"
  task :start_mail_cycle, :roles => :db do
    run "cd #{release_path} && rake mailing:start_send_cycle RAILS_ENV=production"
  end

  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  # desc "Restart mail daemon"
  # task :restart_mail_daemon, :roles => :app do
  #   run "RAILS_ENV=production ruby #{release_path}/lib/mail_daemon.rb restart"
  # end
end
