class User < ActiveRecord::Base
  has_many :messages
  
  validates :slack_id, uniqueness: true
end

class Channel < ActiveRecord::Base
  has_many :messages
  
  validates :slack_id, uniqueness: true
end

class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  
  validates_uniqueness_of :channel_id, :scope => [ :user_id, :timestamp ]
  #validates :channel_id, uniqueness: { scope: [ :user_id, :timestamp ] } #is this how it would be for Rails 4?
end
