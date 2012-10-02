module Kontagent
  class Sidekiqworker
    include Sidekiq::Worker
    sidekiq_options :queue => :Kontagent
  
    def perform(path)
      Kontagent.process(path)
    end
  
    def self.queue=(type)
      sidekiq_options :queue => type
    end
  end
end