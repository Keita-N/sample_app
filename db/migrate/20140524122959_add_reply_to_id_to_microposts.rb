class AddReplyToIdToMicroposts < ActiveRecord::Migration
  def change
  	add_column :microposts, :reply_to_id, :integer
  end
end
