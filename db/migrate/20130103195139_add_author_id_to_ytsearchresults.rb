class AddAuthorIdToYtsearchresults < ActiveRecord::Migration
  def change
    add_column :yt_search_results, :author_id, :integer
  end
end
