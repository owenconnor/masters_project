class SearchConcept < ActiveRecord::Base
	has_ancestry
 	attr_accessible :is_node, :name, :terms, :parent_id, :navigation_node
end
