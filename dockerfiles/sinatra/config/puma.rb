# Puma HTTPD Confi File.
# Default location is config/puma.rb

# Extra .. is required for some reason!
key =  File.expand_path "../../example.key", __FILE__
cert = File.expand_path "../../example.crt", __FILE__
#ca = File.expand_path "../../examples/puma/client-certs/ca.crt", __FILE__

ssl_bind "0.0.0.0", 9292, :cert => cert, :key => key, :verify_mode => "none" #   :verify_mode => "peer", :ca => ca

#app do |env|
#  [200, {}, ["embedded app"]]
#end

#lowlevel_error_handler do |err|
#  [200, {}, ["error page"]]
#end

puts "Loaded puma config with key #{key} and certificate #{cert}"