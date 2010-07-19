# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'dryk'
require 'spec'
require 'spec/autorun'
require 'rack_dav'
require 'tempfile'

Spec::Runner.configure do |config|
  config.before(:each) do
  end
end

app = Rack::Builder.new do
  use Rack::ShowExceptions
  use Rack::CommonLogger
  use Rack::Reloader
  use Rack::Lint
  run RackDAV::Handler.new(:root => Dir.tmpdir)
end.to_app

Rack::Handler::WEBrick.run(app, :Host => '0.0.0.0', :Port => 3003)
