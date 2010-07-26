# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "zip"
  config.gem "authlogic"
  config.gem "aasm"
  config.gem "haml"
  config.gem "inherited_resources", :version => '=1.0.3'
  config.gem "easy_roles", :version => '=0.4.2'
  config.gem "cancan"
  config.gem "spreadsheet"
  config.gem "will_paginate"
  config.gem "paperclip"
  config.gem "simple-daemon"
  config.gem 'delayed_job', :version => '2.0.1'
  config.gem 'exception_notification'
  
  config.time_zone = 'Madrid'
  config.i18n.default_locale = :es
end

ExceptionNotification::Notifier.email_prefix = "[icas-maxwell] "
ExceptionNotification::Notifier.exception_recipients = %w(bugger@beecoder.com)

