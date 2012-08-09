module Kontagent
  def logger=(l)
    @logger = l
  end
  
  def logger
    @logger
  end  
end

require "kontagent/version"
require "kontagent/messages"
require "kontagent/tracking"
require "kontagent/client"
require "kontagent/railtie" if defined?(Rails)
