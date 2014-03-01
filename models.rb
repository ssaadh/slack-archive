class User < ActiveRecord::Base
  has_one :message
  
  validates :slack_id, uniqueness: true
end

class Channel < ActiveRecord::Base
  has_one :message
  
  validates :slack_id, uniqueness: true
end

class Message < ActiveRecord::Base
  belongs_to :users
  belongs_to :channels
  
  #validates_uniqueness_of :channel_id, :scope => [ :user_id, :timestamp ]
  #validates :channel_id, uniqueness: { scope: :user_id, :timestamp } #how to do multiple scope?
end
