# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
gem 'rack', '1.2.0'
require 'rack'
require 'dryk'
require 'spec'
require 'spec/autorun'
require 'rack_dav'
require 'tempfile'
require 'fileutils'

DOC_ROOT = File.join(Dir.tmpdir, 'dryk_9494')
USER_NAME = 'user'
PASSWORD = 'pass'

Spec::Runner.configure do |config|
  config.before(:all) do
    FileUtils.mkdir(DOC_ROOT) unless File.exists?(DOC_ROOT)
    @@rack_dav = Rack::Builder.new do
      use Rack::ShowExceptions
      use Rack::CommonLogger
      use Rack::Reloader
      use Rack::Lint
      use Rack::Auth::Basic do |username, password|
        username == USER_NAME
        password == PASSWORD
      end
      run RackDAV::Handler.new(:root => DOC_ROOT)
    end.to_app
  end

  config.after(:all) do
    FileUtils.rm_rf(DOC_ROOT) if File.exists?(DOC_ROOT)
  end
end

