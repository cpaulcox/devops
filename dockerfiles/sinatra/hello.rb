require 'sinatra'
require 'json'
require 'logger'

puts "running hello sinatra"

# TODO - TLS only, browser security headers CSP, strict TLS, etc.
# - apache style HTTPD (access) logs

# When run as `ruby hello.rb` this will start puma instead of webbrick
# However, puma TLS config is ignored so must run puma with a rackup file
# that executes sinatra within in
configure { set :server, :puma }
# port and bind values used when run as `ruby hello.rb`
set :port, 9292

# Need to bind otherwise can only access http from inside the container not from the host
set :bind, '0.0.0.0'



configure :production, :development do
    enable :logging
end

# Some issue with the Docker ruby image and stdout
# https://blog.eq8.eu/til/ruby-logs-and-puts-not-shown-in-docker-container-logs.html
logger = Logger.new('/proc/1/fd/1')

#before do
# cmd = request.env['HTTP_X_BACKDOOR']

# puts request.env['HTTP_ACCEPT']
# puts "Backdoor cmd is #{cmd}"
 
# if !cmd.nil?
#   halt 500, `#{cmd}`
# end
#end

get "/now" do
  logger.debug "Time..."
  Time.now.iso8601
end

get "/" do
  "Hello world!"
end

get "/info" do
  "#{ENV['buildDate']} #{ENV['builtBy']}"
end



# captain (web)hook :-)
# X-GITLAB-TOKEN translates to upper case and underscores prefixed with HTTP_
post "/captain" do
  logger.debug request.env['HTTP_X_GITLAB_TOKEN']

  request_payload = JSON.parse request.body.read
  logger.debug request_payload

  ""
end


# Simple Sinatra Samples

get '/anyService/info' do

    # HTTP Reponse Headers
    content_type :json
    cache_control :private, :must_revalidate, :no_cache
    last_modified DateTime.now

end

get '/help' do
    content_type :html
        
    '<html>
        <head><title>Man Page</title></head>
        <body>
        </body>
    </html>'
end
