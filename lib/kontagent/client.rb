module Kontagent
  module Client
    extend self
    extend Kontagent::Tracking
  
    TEST_SERVER = "test-server.kontagent.com"
    PROD_SERVER = "api.geo.kontagent.net"
  
    attr_accessor :base_url, :api_key, :test_mode, :debug_mode
  
    def configure(opts = {})
      # by default we initialize TEST_SERVER url
      @test_mode = opts[:test_mode]
      @api_key = opts[:api_key]
      @base_url = @test_mode || opts[:base_url].nil? ? TEST_SERVER : opts[:base_url]
      @debug_mode = opts[:debug_mode]
      @delayed = opts[:delayed]
      set_call(opts[:secure])
    end
    
    def set_call(type)
      @dial_out = Proc.new { |var| type ? secure_call_api(var) : simple_call_api(var) }
    end
  
    # Return the url for the production environment in Kontagent.
    # @returns the production server URL
    def prod_server
      PROD_SERVER
    end
  
    # Return the url for the test environment in Kontagent.
    # @returns the test server URL. As per Kontagent, this url is only to test if there is communication.
    def test_server
      TEST_SERVER
    end
  end
end