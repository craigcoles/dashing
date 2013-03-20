require 'heroku-api'

class LatestHerokuReleases

  Release = Struct.new(:app, :version, :last_commit, :created_at)

  attr_reader :number_of_releases

  def initialize(options = {})
    @number_of_releases = options.fetch(:number_of_releases) { 5 }
  end

  def latest_releases
    latest_releases = []

    apps.each do |app|
      latest_releases << latest_releases_for_app(app)
    end

    latest_releases
  end

  private

  def apps
    @apps ||= client.get_apps.body.map { |app| app['name'] }
  end

  def latest_releases_for_app(app)
    release = client.get_releases(app).body.last

    {
      'version' => release['name'],
      'app' => app,
      'last-commit-by' => release['user'],
      'date' => release['created_at']
    }
  end

  def client
    @client ||= Heroku::API.new
  end
end

SCHEDULER.every '10m', :first_in => 0 do |job|

  releases = LatestHerokuReleases.new

  send_event('heroku_releases', {
    :title => "Recent Heroku releases",
    :releases => releases.latest_releases

  })
end

