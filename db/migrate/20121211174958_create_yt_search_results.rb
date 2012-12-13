class CreateYtSearchResults < ActiveRecord::Migration
  def change
    create_table :yt_search_results do |t|
      t.string :id
      t.date :published
      t.date :updated
      t.string :title
      t.string :description
      t.string :thumbnails
      t.integer :search_id
      t.string :embed_url
      t.string :author_name
      t.string :author_url
      t.string :category
      t.string :keywords
      t.string :player_url
      t.integer :duration
      t.integer :viewcount
      t.string :geo

      t.timestamps
    end
  end
end
