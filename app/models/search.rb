class Search < ActiveRecord::Base
  attr_accessible :context_terms, :search_name, :location, :search_concept_id, :second_language, :vicinity, :video_id
end
