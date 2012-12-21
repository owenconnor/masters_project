class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :video_id
      t.string :search_concept_id
      t.string :location
      t.string :vicinity
      t.string :context_terms
      t.string :second_language

      t.timestamps
    end
  end
end
