class AddNavigationNodeToSearchConcepts < ActiveRecord::Migration
  def change
    add_column :search_concepts, :navigation_node, :boolean
  end
end
