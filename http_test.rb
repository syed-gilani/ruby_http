require "test/unit"
require_relative './http_request_parser'
require_relative './http_response_preparer'
require_relative './http_response'

class HttpRequestParserTest < Test::Unit::TestCase
	def test_parse_basic
		request_obj = 'GET /web_content/tables.html HTTP/1.1'
	
		expected_response = {:headers=>[],
			:method=>"GET",
			:path=>"/web_content/tables.html"}

		assert_equal(expected_response, HttpRequestParser.parse(request_obj))
	end
  
	def test_parse_headers
		request_obj = 'GET /web_content/tables.html HTTP/1.1
		Host: localhost:8080'
	

		expected_response = {:headers=>["\t\tHost: localhost:8080"],
			:method=>"GET",
			:path=>"/web_content/tables.html"}

		assert_equal(expected_response, HttpRequestParser.parse(request_obj))
	end
	
	def test_parse_headers1
		request_obj = 'GET /web_content/tables.html HTTP/1.1
		Host: localhost:8080
		Connection: keep-alive
		Upgrade-Insecure-Requests: 1'
	

		expected_response = {:headers=>["\t\tHost: localhost:8080\n", "\t\tConnection: keep-alive\n", "\t\tUpgrade-Insecure-Requests: 1"],
			:method=>"GET",
			:path=>"/web_content/tables.html"}

		assert_equal(expected_response, HttpRequestParser.parse(request_obj))
	end
end
	
class HttpResponsePreparerTest < Test::Unit::TestCase
	def test_response_success
		response_obj = {:headers=>["\t\tHost: localhost:8080\n", "\t\tConnection: keep-alive\n", "\t\tUpgrade-Insecure-Requests: 1"],
			:method=>"GET",
			:path=>"/web_content/tables.html"}
		response = HttpResponsePreparer.new(server_root:".").prepare(response_obj)
		response_code = response.to_s.lines[0][9..-1].chomp
		mime_type = response.to_s.lines[1][14..-1].chomp
		content_length = response.to_s.lines[2][16..-1].chomp
		assert_equal("200", response_code)
		assert_equal("text/html", mime_type)
		assert_equal("971", content_length)
	end
	
	def test_response_failure
		response_obj = {:headers=>["\t\tHost: localhost:8080\n", "\t\tConnection: keep-alive\n", "\t\tUpgrade-Insecure-Requests: 1"],
			:method=>"GET",
			:path=>"/web_content/abc.html"}
		response_code = HttpResponsePreparer.new(server_root:".").prepare(response_obj).to_s.lines[0][9..-1].chomp
		assert_equal("404", response_code)
	end
end	