require 'spec_helper'

describe "Kontagent::Tracking", "when first created" do
  
  before do
    @client = Kontagent::Client.new
  end
  
  it "should have invalid configuration (missing)" do
    @client.valid?.should == false
  end  
end

