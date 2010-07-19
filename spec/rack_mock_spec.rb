# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "how to use rack-mock" do
  let(:mock_request) { Rack::MockRequest.new(@@rack_dav) }
  let(:server_address) { 'https://127.0.0.1:9494' }

  it "not basic authed access" do
    response = mock_request.get(server_address + '/')
    response.status.should == 401
  end

  it "basic auth missed access" do
    response = mock_request.get(
      server_address + '/',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:badpass"].pack("m*")
    )
    response.status.should_not == 200
  end

  it "basic authed valid access" do
    response = mock_request.get(
      server_address + '/',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
    )
    response.status.should == 200
  end

  it "not uploaded file" do
    response = mock_request.get(
      server_address + '/morning-glory-pool.jpg',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
    )
    response.status.should == 404
  end
  describe "upload sample image file" do
    it "put sample file" do
      files = Rack::Utils::Multipart::UploadedFile.new(File.join(File.dirname(__FILE__), 'fixtures', 'morning-glory-pool.jpg'))
      response = mock_request.put(
        server_address + '/morning-glory-pool.jpg',
        {
          'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*"),
          :params => {
            'submit-name' => 'user',
            'files' => files
          }
        }
      )
      response.status.should == 200
    end
    it "check file uploaded" do
      response = mock_request.get(
        server_address + '/morning-glory-pool.jpg',
        'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
      )
      response.status.should == 200
    end
  end
end
