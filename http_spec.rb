require 'minitest/autorun'
require_relative './http_request_parser'
require_relative './http_response_preparer'


describe HttpRequestParser do
	describe "parse valid http request" do
		let(:request_obj) {'GET /web_content/tables.html HTTP/1.1'}
		let(:expected_response) {{:headers=>[],:method=>"GET",:path=>"/web_content/tables.html"}}
		it "checks request parsing for a valid http request" do
			HttpRequestParser.parse(request_obj).must_equal expected_response
		end
	end
	
	describe "parse valid request's headers" do
		let(:request_obj) {'GET /web_content/tables.html HTTP/1.1
		Host: localhost:8080'}
		let(:expected_response) {{:path=>"/web_content/tables.html",:method=>"GET", :headers=>["\t\tHost: localhost:8080"]}}
		it "checks parsing request headers for a valid http request" do
			HttpRequestParser.parse(request_obj).must_equal expected_response
		end
	end
	
	describe "parse valid request's additional headers" do
		let(:request_obj) {'GET /web_content/tables.html HTTP/1.1
		Host: localhost:8080
		Connection: keep-alive
		Upgrade-Insecure-Requests: 1'}
		let(:expected_response) {{:path=>"/web_content/tables.html",:method=>"GET", :headers=>["\t\tHost: localhost:8080\n", "\t\tConnection: keep-alive\n", 
				"\t\tUpgrade-Insecure-Requests: 1"]}}
		it "checks parsing request additional headers for a valid http request" do
			HttpRequestParser.parse(request_obj).must_equal expected_response
		end
	end
end

describe HttpResponsePreparer do
	describe "Test http response for a valid http request" do
		let(:request_obj) {{:headers=>["\t\tHost: localhost:8080\n", "\t\tConnection: keep-alive\n", "\t\tUpgrade-Insecure-Requests: 1"],
			:method=>"GET",
			:path=>"/web_content/tables.html"}}
		it "checks http response for a valid http request" do
			HttpResponsePreparer.new(server_root:".").prepare(request_obj).to_s.lines[0][9..-1].chomp.must_equal "200"
			HttpResponsePreparer.new(server_root:".").prepare(request_obj).to_s.lines[1][14..-1].chomp.must_equal "text/html"
			HttpResponsePreparer.new(server_root:".").prepare(request_obj).to_s.lines[2][16..-1].chomp.must_equal "971"
		end
	end
	
	describe "Test http response for invalid http request" do
		let(:request_obj) {{:headers=>["\t\tHost: localhost:8080\n", "\t\tConnection: keep-alive\n", "\t\tUpgrade-Insecure-Requests: 1"],
			:method=>"GET",
			:path=>"/web_content/xyz.html"}}
		it "checks http response for invalid http request" do
			HttpResponsePreparer.new(server_root:".").prepare(request_obj).to_s.lines[0][9..-1].chomp.must_equal "404"
		end
	end
end