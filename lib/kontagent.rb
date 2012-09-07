module Kontagent
  def self.logger=(l)
    @logger = l
  end
  
  def self.logger
    @logger
  end  
end

Kontagent.logger = Logger.new(STDOUT)

require "kontagent/version"
require "kontagent/messages"
require "kontagent/tracking"
require "kontagent/client"
require "kontagent/railtie" if defined?(Rails)
