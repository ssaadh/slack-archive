require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:///db/uh.sqlite3"

require './models'
require './slack'

before do
  token = 0
  @slack = Slack.new token
end

get '/hi' do
  "Hello World!"
end

##

get '/slack/users' do
  slack_api_lists( 'user', 'members', User )
end

get '/slack/channels' do
  slack_api_lists( 'channel', 'channels', Channel )
end

def slack_api_lists( method_name, response_hash, model_class )
  response = @slack.send "#{method_name}_list"
  return 'API call failed' if response[ 'ok' ] == false
  
  list = response[ response_hash ]
  list.each do |individual|
    slack_id = individual[ 'id' ]
    name = individual[ 'name' ]
    
    model_class.create( slack_id: slack_id, name: name )
  end
  
  return 'Done'
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
