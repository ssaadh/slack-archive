class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    
      t.integer :channel_id
      t.integer :user_id
      t.string :subtype
      t.string :text
      t.datetime :timestamp

      t.timestamps
    end
  end
end
