namespace:api do
  desc "apiをしゅとくして保存するこーど"
  task :get do
    require 'net/http'

    response = Net::HTTP.get(URI.parse('https://api.bitflyer.jp/v1/getchats?form_date:20180206'))

    print response
  end
end
