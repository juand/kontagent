module Kontagent; end

require "kontagent/version"
require "kontagent/logger"
require "kontagent/messages"
require "kontagent/tracking"
require "kontagent/client"
require "kontagent/railtie" if defined?(Rails)
