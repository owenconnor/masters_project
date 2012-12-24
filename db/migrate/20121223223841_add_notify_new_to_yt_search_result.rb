class AddNotifyNewToYtSearchResult < ActiveRecord::Migration
  def change
  	add_column :yt_search_results, :notify_new, :boolean, :default => false
  end
end
