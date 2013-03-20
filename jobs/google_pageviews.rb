require 'garb'

# google username
username = ''
# google password
password = ''
# google api key
api_key  = ''

# google analytics ua (make sure the UA- is there)
ua = 'UA-'

Garb::Session.api_key = api_key
Garb::Session.login(username, password)


class PageViews
  extend Garb::Model
  
  metrics :pageviews
  # this could be :day, :month, :year
  dimensions :month
end

account = Garb::Management::Account.all.first
profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == ua}

SCHEDULER.every '1m', :first_in => 0 do
  views = PageViews.results(
    profile,
	  :limit => 1,
    :start_date => Date.new(Time.now.year,Time.now.month,1).to_time
  )
  send_event('page_views',   { current: views.first.pageviews, site: account.name })
end