class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :author_name
      t.string :author_url
      t.integer :trusted_uploader_rank

      t.timestamps
    end
  end
end
