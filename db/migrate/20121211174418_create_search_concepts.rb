class CreateSearchConcepts < ActiveRecord::Migration
  def change
    create_table :search_concepts do |t|
      t.string :name
      t.string :terms
      t.boolean :is_node

      t.timestamps
    end
  end
end
