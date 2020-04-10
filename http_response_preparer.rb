require './http_response'

# Map extensions to their content type
CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt' => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg'
}

# Treat as binary data if content type cannot be found
DEFAULT_CONTENT_TYPE = 'application/octet-stream'

class HttpResponsePreparer

  def initialize(server_root:)
    @server_root = server_root
  end

  def prepare(request)
    puts request.fetch(:path)
    if request.fetch(:path) == '/'
      respond_with(@server_root + "index.html")
    else
      respond_with(@server_root + request.fetch(:path))
    end
  end

  def content_type(path)
    ext = File.extname(path).split(".").last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def respond_with(path)
    if File.exists?(path)

      send_ok_response(File.binread(path), content_type(path))
    else
      send_file_not_found
    end
  end

  def send_ok_response(data, content_type)
    HttpResponse.new(code: 200, data: data, content_type: content_type)
  end

  def send_file_not_found
    HttpResponse.new(code: 404)
  end

end
