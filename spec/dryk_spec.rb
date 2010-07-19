# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Dryk" do
  it "create instance" do
    lambda {
      @dryk = Dryk.new
    }.should_not raise_error
  end
end
describe "create collections" do
  let(:mock_request) { Rack::MockRequest.new(@@rack_dav) }
  let(:dorayaki) { Dryk.new }
  it "input directories" do
    dorayaki.directories = get_directories
    dorayaki.directories.should == get_directories
  end
end
def get_directories
  Dir.glob('spec/fixtures/**/')
end
