class Kontagent::Client
  include Kontagent::Tracking
  
  TEST_SERVER = "test-server.kontagent.com"
  PROD_SERVER = "api.geo.kontagent.net"
  
  attr_accessor :base_url, :api_key, :test_mode
  
  def initialize(opts = {})
    # by default we initialize TEST_SERVER url
    @test_mode = opts[:test_mode]
    @api_key = opts[:api_key]
    @base_url = @test_mode || opts[:base_url].nil? ? TEST_SERVER : opts[:base_url]
  end
end