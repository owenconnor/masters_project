class Author < ActiveRecord::Base
  	attr_accessible :author_name, :author_url, :trusted_uploader_rank
end
