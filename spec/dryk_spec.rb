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
  let(:request) { Rack::MockRequest.new(@@rack_dav) }
  let(:dorayaki) { Dryk.new }
  let(:server_address) { 'https://127.0.0.1:9494' }
  it "sort by creatable order" do
    directories = CreatableOrderArray.new(get_directories).sort
    directories.should == ['/foo/', '/abc/', '/foo/bar/']
  end
  it "no collections" do
    dorayaki.handler = request
    dorayaki.server = server_address
    dorayaki.webdav_directory('/foo/').should == 404
    dorayaki.webdav_directory('/abc/').should == 404
    dorayaki.webdav_directory('/foo/bar/').should == 404
  end
  it "make collections" do
    dorayaki.handler = request
    dorayaki.server = server_address
    directories = CreatableOrderArray.new(get_directories).sort
    dorayaki.make_collections directories
    dorayaki.webdav_directory('/foo/').should == 200
    dorayaki.webdav_directory('/abc/').should == 200
    dorayaki.webdav_directory('/foo/bar/').should == 200
  end
end
def get_directories
  [
    '/foo/bar/',
    '/abc/',
    '/foo/',
  ]
end
