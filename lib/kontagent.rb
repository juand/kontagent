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
require "kontagent/sidekiq_worker" if defined?(Sidekiq)
require "kontagent/resque_worker" if defined?(Resque)
