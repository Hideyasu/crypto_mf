namespace:api do
  desc "apiをしゅとくして保存するこーど"
  task :get do
    require 'net/http'
    require 'uri'
    require 'json'

    uri = "https://api.bitflyer.jp/v1/getchats?form_date:#{Date.today.strftime("%Y-%m-%d")}"

    response = Net::HTTP.get(URI.parse(uri))

    print response
  end
end
