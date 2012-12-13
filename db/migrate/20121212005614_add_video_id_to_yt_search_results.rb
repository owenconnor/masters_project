class AddVideoIdToYtSearchResults < ActiveRecord::Migration
  def up
  	add_column :yt_search_results, :video_id, :string
  end

  def down
  	remove_column :yt_search_results, :video_id
  end
end

