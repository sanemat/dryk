# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Dryk" do
  let(:mock_request) { Rack::MockRequest.new(@@rack_dav) }
  it "create instance" do
    lambda {
      @dryk = Dryk.new
    }.should_not raise_error
  end
end
