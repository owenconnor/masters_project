class YtSearchResult < ActiveRecord::Base
  	attr_accessible :author_name, :author_url, :category, :description, :duration, :embed_url, :geo, :id, :keywords, :player_url, :published, :search_id, :thumbnails, :title, :updated, :viewcount, :video_id, :thumbnails

  	def arrange_search_terms

  		logger.debug "arrange_search_terms"

  	end


end
