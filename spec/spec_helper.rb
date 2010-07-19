# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'dryk'
require 'spec'
require 'spec/autorun'
require 'rack_dav'
require 'tempfile'
require 'fileutils'

DOC_ROOT = File.join(Dir.tmpdir, 'dryk_11112')
Spec::Runner.configure do |config|
  config.before(:each) do
    FileUtils.mkdir(DOC_ROOT) unless File.exists?(DOC_ROOT)
    app = Rack::Builder.new do
      use Rack::ShowExceptions
      use Rack::CommonLogger
      use Rack::Reloader
      use Rack::Lint
      run RackDAV::Handler.new(:root => DOC_ROOT)
    end.to_app

    Rack::Handler::WEBrick.run(app, :Host => '0.0.0.0', :Port => 3003)
  end

  config.after(:each) do
    FileUtils.rm_rf(DOC_ROOT) if File.exists?(DOC_ROOT)
  end
end

