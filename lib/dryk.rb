# coding: utf-8
class Dryk
  attr_accessor :directories
  attr_writer   :handler, :server
  def sort!
    @directories.sort! { |a, b| a.count('/') <=> b.count('/') }
  end
  def webdav_directory(path)
    @handler.get(
      @server + path,
      'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
    ).status
  end
  def make_collections
    @directories.each do |directory|
      if webdav_directory(directory) == 404
        @handler.request(
          'MKCOL',
          @server + directory,
          'HTTP_AUTHORIZATION' => 'Basic ' + ["user:pass"].pack("m*")
        )
      end
    end
  end
end
