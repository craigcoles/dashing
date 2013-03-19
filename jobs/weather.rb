require 'open-uri'
require 'xmlsimple'

woe_id = 13963
format = 'c'

SCHEDULER.every '15m', :first_in => 0 do |job|
  http = Net::HTTP.new('weather.yahooapis.com')
  response = http.request(Net::HTTP::Get.new("/forecastrss?w=#{woe_id}&u=#{format}"))
  weather_data = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['item']['condition']
  weather_location = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['location']
  send_event('weather', { :temp => "#{weather_data['temp']}&deg;#{format.upcase}", :condition => weather_data['text'], :title => "#{weather_location['city']} Weather"})
end