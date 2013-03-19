require 'open-uri'
require 'xmlsimple'

username = 'wearebeef'
api_key = 'ffbc2f708f72a1dd505cd88962b8a61f'

SCHEDULER.every '1m', :first_in => 0 do |job|

	http = Net::HTTP.new('ws.audioscrobbler.com')

	response = http.request(Net::HTTP::Get.new("/2.0/?method=user.getrecenttracks&user=#{username}&api_key=#{api_key}"))
	user_id = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['recenttracks']
	song = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['recenttracks']['track'][0]
  send_event('lastfm', { :cover => song['image'][2]['content'], :artist => song['artist']['content'], :name => song['name'] })

end