class AddRankingColumnsToYtsearchresults < ActiveRecord::Migration
  def change
    add_column :yt_search_results, :geo_rank, :integer
    add_column :yt_search_results, :search_terms_rank, :integer
    add_column :yt_search_results, :location_mention_rank, :integer
    add_column :yt_search_results, :trusted_uploader_rank, :integer
    add_column :yt_search_results, :ahp_rank, :integer
  end
end
