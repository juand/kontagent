module Kontagent
  class Railties < ::Rails::Railtie
    initializer 'Rails logger' do
      Kontagent.logger = Rails.logger
    end
  end
end