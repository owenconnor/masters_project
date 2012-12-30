class ChangeColumnDescriptionToText < ActiveRecord::Migration
  def up
  	change_column :yt_search_results, :description, :text
  end

  def down
  	change_column :yt_search_results, :description, :string
  end
end
