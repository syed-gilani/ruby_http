require 'socket'
require 'io/wait'
require 'yaml'
require './http_request_parser'
require './http_response_preparer'




config = YAML::load_file(File.join(__dir__, 'config.yml'))

# Server Root directory from wehre files are served
SERVER_ROOT = config['rootdir']
server  = TCPServer.new('localhost', config['port'])
puts "HTTP Server started"

loop {
  client  = server.accept
  puts "Recieved a new connection"

  Thread.new do
    begin
      request = client.readpartial(2048)
    rescue EOFError
      puts "EOF Exception caught"
      Thread.exit
    end
    request  = HttpRequestParser.parse(request)
    response = HttpResponsePreparer.new(server_root:SERVER_ROOT).prepare(request)
    puts "sending response to client"
    puts response.to_s.lines[0][9..-1]
    response.send(client)
    client.close
  end
}
