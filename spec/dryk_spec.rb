require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Dryk" do
  before(:all) do
    @mock_request  = Rack::MockRequest.new(@@rack_dav)
  end
  it "create instance" do
    lambda {
      @dryk = Dryk.new
    }.should_not raise_error
  end
  it "mock_request valid?" do
    response = @mock_request.get('https://127.0.0.1:9494/')
    response.status.should == 401

    response = @mock_request.get(
      'https://127.0.0.1:9494/',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:badpass"].pack("m*")
    )
    response.status.should_not == 200

    response = @mock_request.get(
      'https://127.0.0.1:9494/',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
    )
    response.status.should == 200

    response = @mock_request.get(
      'https://127.0.0.1:9494/morning-glory-pool.jpg',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
    )
    response.status.should == 404
    files = Rack::Utils::Multipart::UploadedFile.new(File.join(File.dirname(__FILE__), 'fixtures', 'morning-glory-pool.jpg'))
    response = @mock_request.put(
      'https://127.0.0.1:9494/morning-glory-pool.jpg',
      {
        'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*"),
        :params => {
          'submit-name' => 'user',
          'files' => files
        }
      }
    )
    response.status.should == 200
    response = @mock_request.get(
      'https://127.0.0.1:9494/morning-glory-pool.jpg',
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
    )
    response.status.should == 200

  end
end
