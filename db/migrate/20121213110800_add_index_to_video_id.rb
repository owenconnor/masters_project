class AddIndexToVideoId < ActiveRecord::Migration
  def up
  	add_index :yt_search_results, :video_id, :unique => true
  end

  def down
  	remove_index :yt_search_results, :video_id
  end
end
