require File.join(File.dirname(__FILE__), "..", "config", "environment")
require "simple-daemon"

class MailDaemon < SimpleDaemon::Base
  SimpleDaemon::WORKING_DIRECTORY = "#{RAILS_ROOT}/log"

  def self.start
    loop do
      Mail.process(:limit => 50)
      sleep(30)
    end
  end

  def self.stop
  end
end

MailDaemon.daemonize 
