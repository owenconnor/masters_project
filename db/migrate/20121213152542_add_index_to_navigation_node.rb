class AddIndexToNavigationNode < ActiveRecord::Migration
  def up
  	add_index :search_concepts, :navigation_node, :default => false
  end

  def down
  	remove_index :search_concepts, :navigation_node
  end
end
