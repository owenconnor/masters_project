class ChangeIntegerToDecimals < ActiveRecord::Migration
  def change
    change_column :yt_search_results, :geo_rank, :decimal, :precision => 6, :scale => 4, :null => false, :default => 1
    change_column :yt_search_results, :search_terms_rank, :decimal, :precision => 6, :scale => 4, :null => false, :default => 1
    change_column :yt_search_results, :location_mention_rank, :decimal, :precision => 6, :scale => 4, :null => false, :default => 1
    change_column :yt_search_results, :trusted_uploader_rank, :decimal, :precision => 6, :scale => 4, :null => false, :default => 1
    change_column :yt_search_results, :ahp_rank, :decimal, :precision => 6, :scale => 4, :null => false, :default => 1
  end
end
