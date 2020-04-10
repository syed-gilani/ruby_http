class HttpResponse
  def initialize(code:, data: "", content_type: DEFAULT_CONTENT_TYPE)
    @response =
    "HTTP/1.1 #{code}\r\n" +
    "Content-Type: #{content_type}\r\n" +
    "Content-Length: #{data.size}\r\n" +
    "\r\n" +
    "#{data}\r\n"
  end
  def send(client)
    client.write(@response)
  end
  def to_s
    "#{@response}"
  end
end
