module Kontagent
  def self.logger=(l)
    @logger = l
  end
  
  def self.logger
    @logger
  end
  
  def self.process(url)
    Kontagent::Client.process(url)
  end
end

Kontagent.logger = Logger.new(STDOUT)

require "kontagent/version"
require "kontagent/messages"
require "kontagent/tracking"
require "kontagent/client"
require "kontagent/railtie" if defined?(Rails)

has_sidekiq = begin
  require 'sidekiq'
  true
rescue LoadError
  false
end
require "kontagent/sidekiqworker" if has_sidekiq


has_resque = begin
  require 'resque'
  true
rescue LoadError
  false
end
require "kontagent/resqueworker" if has_resque