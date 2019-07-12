require "sinatra"

set :port, 8080

# Need to bind otherwise can only access http from inside the container not from the host
set :bind, '0.0.0.0'

get "/" do
  "Hello world!"
end

get "/info" do
  "#{ENV['buildDate']} #{ENV['builtBy']}"
end


get "/now" do
  Time.now.iso8601
end
