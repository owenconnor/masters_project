class AddThumbnailToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :thumbnail, :string
  end
end
