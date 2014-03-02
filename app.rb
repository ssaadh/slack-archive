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

get '/slack/channel/messages/:name' do
  current_channel = Channel.find_by( name: params[ :name ] )
  history = nil
  last_message = 0
  has_more = true
  first_timestamp = nil  
  
  count = 0
  loop do
    last_message = history[ 'messages' ].last[ 'ts' ] if !history.nil?
    
    # api call
    history = @slack.channel_history current_channel.slack_id, last_message
    return 'API call failed' if history[ 'ok' ] == false
    
    # assign
    current_history = history[ 'messages' ]
    has_more = history[ 'has_more' ]
    
    first_timestamp = current_history.first[ 'ts' ].to_f if count == 0
    
    # see if latest message has already been retrieved
    if !current_channel.last_check.nil?
      break if current_channel.last_check >= first_timestamp
    end
    
    # loop over messages
    current_history.each do |individual|
      next if individual[ 'hidden' ] == true
            
      subtype = nil
      subtype = individual[ 'subtype' ] if individual.has_key? 'subtype'      
      
      if subtype == 'file_comment'
        user = User.find_by( slack_id: individual[ 'comment' ][ 'user' ] )
        text = individual[ 'comment' ][ 'comment' ]
      else
        user = User.find_by( slack_id: individual[ 'user' ] )
        text = individual[ 'text' ]
      end
      
      Message.create( channel_id: current_channel.id, user_id: user.id, subtype: subtype, text: text, timestamp: individual[ 'ts' ].to_f )
    end
    
    count += 1
    break if has_more == false
  end
  
  # Thinking is, if code breaks at some point in between and not all older messages have been saved to the database, this value won't get updated.
  # So next time, method will go through messages again instead of just stopping because the database has the most recent message.
  current_channel.last_check = first_timestamp if !first_timestamp.nil?
  current_channel.save
  
  return 'Done'
end

##

get '/channel/:name' do
  current_channel = Channel.find_by( name: params[ :name ] )
  @all_messages = Message.where( channel_id: current_channel.id ).order( :timestamp )
end
