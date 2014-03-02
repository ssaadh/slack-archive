class ChangeTimestampColumnTypeInMessages < ActiveRecord::Migration
  def change
    change_column :messages, :timestamp, :decimal
    change_column :channels, :last_check, :decimal
  end
end
