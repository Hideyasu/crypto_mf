# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'net/http'
require 'uri'
require 'json'

#今日のぶんのチャットを取得して配列に
uri = "https://api.bitflyer.jp/v1/getchats?form_date:#{Date.today.strftime("%Y-%m-%d")}"
response = Net::HTTP.get(URI.parse(uri))
result = JSON.parse(response)

result.each do |data|
  chats_data.create(nickname:data['nickname'], message:data['message'], date:data['date'])
end
