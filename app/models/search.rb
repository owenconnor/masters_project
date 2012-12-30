class Search < ActiveRecord::Base
  attr_accessible :context_terms, :search_name, :location, :search_concept_id, :second_language, :vicinity, :date_range, :notification_count, :active_search
  validates_presence_of :search_name, :date_range
end
