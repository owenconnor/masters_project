class Author < ActiveRecord::Base
	has_many :yt_search_results
  	attr_accessible :author_name, :author_url, :trusted_uploader_rank
end
