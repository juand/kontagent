module Kontagent
  def self.logger=(l)
    @logger = l
  end
  
  def self.logger
    @logger
  end
  
  class Railties < ::Rails::Railtie
    initializer 'Rails logger' do
      Kontagent.logger = Rails.logger
    end
  end
end