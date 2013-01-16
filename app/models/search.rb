class Search < ActiveRecord::Base
	belongs_to :users
	attr_accessible :context_terms, :search_name, :location, :search_concept_id, :second_language, :date_range, :notification_count, :active_search, :thumbnail, :latitude, :longitude, :user_id
	validates_presence_of :search_name, :date_range
	geocoded_by :location
	after_validation :geocode, :if => :location_changed?
end
