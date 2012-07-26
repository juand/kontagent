require 'spec_helper'

describe "Kontagent::Client", "when first created" do
  
  before do
    @client = Kontagent::Client.new
  end
  
  it "should has base_url set to test server" do
    @client.base_url = "test-server.kontagent.com"
  end

  it "should has no api_key set yet" do
    @client.api_key.should == nil
  end

  it "we should be able to set api_key and check it's presence" do
    @client.api_key = "api_key_1234"
    @client.api_key.should == "api_key_1234"
  end
  
end