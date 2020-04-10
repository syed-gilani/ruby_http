# ruby_http: a minimal http ruby server

Instruction for running the http server
=========

Extract the files from the zip archive. cd into the folder with the extracted files. 
There is a config.yaml file with configurations for server_root, the server root folder and the port. 
Change the two configs to make the webserver host files from the root folder and to listen on the configured port.
After config.yaml is updated, run the following command to start the server:
			
			ruby http.rb

You can now use a web browser or curl to make HTTP requests to the server.
if you just use the localhost:port with the filename, web server will return the default index.html file from the server root folder,
if it exists.

Instructions for running the Tests
=========

There is a file http_test.rb that contains some unit tests using ruby unit test library. You can run the tests using the following command
			
			ruby http_test.rb
		
Instructions for running BDD tests developed using Minitest
=========

There is a file named http_spec.rb that contains test using the BDD paradigm. Run the tests by using the following command:
			
			bundle exec ruby http_spec.rb

This assumes that bundler gem is installed. If it's not installed, then install it using the folowing command

			gem install bundler
