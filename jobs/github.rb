require 'net/http'
require 'json'

github_username = 'users/beef'

SCHEDULER.every '1d', :first_in => 0 do |job|
  http = Net::HTTP.new("api.github.com", Net::HTTP.https_default_port())
  http.use_ssl = true
  response = http.request(Net::HTTP::Get.new("/#{github_username}"))
  data = JSON.parse(response.body)

  if response.code != "200"
    puts "github api error (status-code: #{response.code})\n#{response.body}"
  else
    send_event('github_userinfo_followers', current: data['followers'])
    send_event('github_userinfo_repos', current: data['public_repos'])
  end
end