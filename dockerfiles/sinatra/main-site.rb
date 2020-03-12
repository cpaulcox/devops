require 'sinatra'
require 'json'

get '/hi1' do
    content_type :html
    
    '<html>
        <head><title>POSTer</title></head>
        <body>
          <h1>xxxx</h1>
          <form action="/hi2" method="post">
            <input type="submit">
          </form>
          <p>
          <a href="/products">Click for Products</a>
          </p>
        </body>
    </html>'
end

post '/hi2' do
    content_type :html
    
    '<html>
        <head><title></title></head>
        <body>
          <h1>hello</h1>
        </body>
    </html>'
end

# use of etag
get '/products' do
   
    #list_headers
    
    eTagVal = request.env['HTTP_IF_NONE_MATCH']
   
    if eTagVal == '"summer"'
        log.debug 'same etag'
        etag :winter
    else
    log.debug "in here 2"    
    etag :summer
    log.debug "in here 3"    
        
    end
    
    content_type :json
    log.debug "in here 1"
    
    cache_control :public, :must_revalidate, :max_age => 60, :s_maxage => 60
    {'123123' => {:sku => '123123', :dept => [:F, :shoes, :casual] , :price => 10.50,  # array of prices by currency?  How to sort?
                 :sizes => [4, 5, 6, 6.5], :desc => 'laced red deck shoes'} }.to_json
    
end

def list_headers()

    request.env.each_pair do |k,v|
     puts k
    end

end
