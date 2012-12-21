class RemoveColumnsFromSearches < ActiveRecord::Migration
  def up
  	remove_column :searches, :video_id
  end

  def down
  	add_column :searches, :video_id, :string
  end
end
