class AddIndexToAuthors < ActiveRecord::Migration
  def change
  	add_index :authors, :author_url, :unique => true
  end
end
