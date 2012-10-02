module Kontagent
  class Resqueworker
    @queue = 'Kontagent'
  
    def self.queue=(type)
      @queue = type
    end
  
    def self.perform(path)
      Kontagent.process(path)
    end
  end
end