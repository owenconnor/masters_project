class AddAncestryToSearchConcepts < ActiveRecord::Migration
def self.up
    add_column :search_concepts, :ancestry, :string
    add_index :search_concepts, :ancestry
  end

  def self.down
    remove_index :search_concepts, :ancestry
    remove_column :search_concepts, :ancestry
  end
end
