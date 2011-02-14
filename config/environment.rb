# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "newrelic_rpm"
  config.gem "zip"
  config.gem "authlogic"
  config.gem "aasm"
  config.gem "haml"
  config.gem "nokogiri"
  config.gem "inherited_resources", :version => '=1.0.3'
  config.gem "easy_roles", :version => '=0.4.2'
  config.gem "cancan", :version => '1.0.2'
  config.gem "spreadsheet"
  config.gem "will_paginate"
  config.gem "paperclip"
  config.gem "simple-daemon"
  config.gem 'delayed_job', :version => '2.0.1'
  config.gem 'exception_notification'
  #  config.gem 'fastercsv', :version => '1.5.4'
  
  config.time_zone = 'Madrid'
  config.i18n.default_locale = :es
  config.action_controller.resources_path_names = { :new => 'nuevo', :edit => 'cambiar' }
end

#Mime::Type.register 'application/pdf', :pdf
Mime::Type.register "application/vnd.ms-excel", :xls

ExceptionNotification::Notifier.email_prefix = "[icasmailing] "
ExceptionNotification::Notifier.exception_recipients = %w(danigb@gmail.com)

