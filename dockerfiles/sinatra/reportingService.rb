require 'sinatra'
require 'json'
require 'java'
require 'sequel'

def init_connection

  host_name = "abc1234.tesco.org"
  db_name   = "DRTPSO05_STORED_VALUE.ukroi.tesco.org" # SID
  userid    =  "dbUser"
  password  = "password1"

  url = "jdbc:oracle:thin:#{userid}/#{password}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=#{host_name})(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=#{db_name})))"

  db = Sequel.connect(url)
  db
end

get '/StoredValueService/statistics/accounts' do

    content_type :json
    cache_control :private, :must_revalidate, :no_cache
    last_modified DateTime.now

    DB = init_connection

    dataset = DB[:ACCOUNT]
    response = []
    dataset.map { |row| response.push({accountId: row[:account_id], customerId: row[:customer_id]}) }
    response.to_json
end

get '/help' do
    content_type :html
        
    '<html>
        <head><title>Man Page</title></head>
        <body>
        </body>
    </html>'
end
