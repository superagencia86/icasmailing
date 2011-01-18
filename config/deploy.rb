############################################################
#	Application
#############################################################

require 'erb'

set :application, "icasmailing"
set :domain, "superagencia86.com"
server domain, :app, :web
role :db, domain, :primary => true
set :rails_env, 'production'

#############################################################
#	Servers
#############################################################
#

#set :deploy_to, "/home/superage/produccion/#{application}"
#set :user, "superage"

set :deploy_to, "/home/deploy/#{application}"
set :user, "deploy"


#############################################################
#	Settings
#############################################################
 
default_run_options[:pty] = true
set :keep_releases, 2
set :use_sudo, false 

 
#############################################################
#	Git
#############################################################
 
set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :repository,  'git://github.com/superagencia86/icasmailing.git'

# before "deploy:stop_mail_daemon"
after "deploy:update_code", "db:symlink" # , "deploy:restart_mail_daemon"
#after "deploy:symlink", "deploy:start_mail_cycle"
 
namespace :db do
  desc "Make symlink for database yaml, mongrel cluster"
  task :symlink do     
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"      
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"      
    #run "ln -nfs #{shared_path}/public/campaign #{release_path}/public/campaign"
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

namespace :mysql do
  desc "Backup the remote production database"
  task :backup, :roles => :db, :only => { :primary => true } do
    filename = "#{application}.dump.#{Time.now.to_i}.sql.bz2"
    file = "/tmp/#{filename}"
    on_rollback { delete file }
    production = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result)['production']

    pass_ops = !production['password'].nil? ? "--password=#{production['password']}" : ''

    run "mysqldump -u #{production['username']} #{pass_ops} #{production['database']} | bzip2 -c > #{file}"  do |ch, stream, data|
      puts data
    end
    `mkdir -p #{File.dirname(__FILE__)}/../backups/`
    get file, "backups/#{filename}"
    `gpg -c #{File.dirname(__FILE__)}/../backups/#{filename}`
    `rm #{File.dirname(__FILE__)}/../backups/#{filename}`
    # delete file
  end

  task :download, :roles => :db, :only => { :primary => true } do
    filename = "#{application}.dump.sql"
    file = "/tmp/#{filename}"
    on_rollback { delete file }
    db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result)
    production = db['production']

    pass_ops = !production['password'].nil? ? "--password=#{production['password']}" : ''
    run "mysqldump -u #{production['username']} #{pass_ops} #{production['database']} > #{file}"  do |ch, stream, data|
      puts data
    end
    get file, "tmp/#{filename}"
    #`mysql -u root -p booka < tmp/#{filename}`
    # delete file
  end
end