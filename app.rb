require 'sinatra'

require 'slack'

before do
  token = 0
  @slack = Slack.new token
end

get '/hi' do
  "Hello World!"
end

##

get '/slack/users' do
  users = @slack.user_list
  return 'API call failed' if users[ 'ok' ] == false
  
  users_list = users[ 'members' ]
  users_list.each do |user|
    slack_id = user[ 'id' ]
    name = user[ 'name' ]
  end
end

get '/slack/channels' do
  channels = @slack.channel_list
  return 'API call failed' if channels[ 'ok' ] == false
  
  channels_list = users[ 'members' ]
  channels_list.each do |channel|
    slack_id = channel[ 'id' ]
    name = channel[ 'name' ]
  end
end

get '/slack/channel/:name' do
  history = @slack.channel_history params[ :name ]
  return 'API call failed' if history[ 'ok' ] == false
  
  current_history = history[ 'messages' ]
  has_more = history[ 'has_more' ]
end

##

get '/channel/:name' do
  current_channel = Channel.find_by( name: params[ :name ] )
  @all_messages = Message.where( channel_id: current_channel.id ).order( :timestamp )
end
