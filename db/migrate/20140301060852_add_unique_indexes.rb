class AddUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :users, :slack_id, :unique => true
    add_index :channels, :slack_id, :unique => true
    add_index :messages, [ :channel_id, :user_id, :timestamp ], :unique => true
    add_index :messages, :timestamp
  end
end
