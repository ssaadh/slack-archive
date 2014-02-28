require 'httparty'

class Slack
  attr_reader :token
  
  def initialize token
    @token = token
  end

  def channel_list
    options = { token: token }
    HTTParty.post( "#{beginning_url}/channels.list", body: options )
  end
  
  def user_list
    options = { token: token }
    HTTParty.post( "#{beginning_url}/users.list", body: options )
  end
  
  def channel_history channel, latest = 0, count = 1000
    options = { token: token, channel: channel, latest: latest, count: count }
    HTTParty.post( "#{beginning_url}/channels.history", body: options )
  end

  private

    def beginning_url
      'https://slack.com/api'
    end
end
