class RankVideosWorker
	include Sidekiq::Worker

	def perform
		all_unranked_video = YtSearchResult.all

		all_unranked_video.each do |video|
			#Add a score if the video has a geolocation
			if video.geo == "No Geolocation"
				geo_score = 1
			else 
				geo_score = 3
			end

			#See if the title and desciption carry many occurences of the search terms
			#find all the search terms from both the concept and context terms
			search = Search.find(video.search_id)
			search_concept = SearchConcept.find(search.search_concept_id)

			#Iterate over the terms seeing how often they occur
			context_term_current_score = 0
			#puts "context_terms"
			#puts search.context_terms
			if search.context_terms == "" || nil
				title_score = 1
			else

				search.context_terms.split(",").each do |context_term|
				#	logger.debug "context_term: #{context_term}"
					occurence = video.title.scan(/#{context_term}/).length
					context_term_freqeuncy = video.title.scan(/#{context_term}/).length
					context_term_current_score = context_term_current_score.to_i + context_term_freqeuncy.to_i
				end
				
				concept_term_current_score = 0
				search_concept.terms.split(",").each do |concept_term|
					concept_term_freqeuncy = video.title.scan(/#{concept_term}/).length
					concept_term_current_score = concept_term_current_score.to_i + concept_term_freqeuncy.to_i
				end
				#Return a score ranked by where they appear and if they are concept terms or context terms
				#context being more important then concept 
				title_score = (concept_term_current_score*3) + (context_term_current_score*4)
				#logger.debug "title_score:#{title_score}"
				#puts title_score
			end


			#See if the exact location is mentioned in the title and description and derive a score
			location_term_current_score = 0
			accurate_location = 7
			named_search_location = search.location.split(/[\s,]+/)
			named_search_location.each do |location_term|
				#Return a Score based on how often the location appears
				location_term_freqeuncy = (video.title.scan(/#{location_term}/).length)*accurate_location
				location_term_current_score = location_term_current_score.to_i + location_term_freqeuncy.to_i
				#the broader a location term the less valuable eg locality, city, country
				accurate_location = accurate_location - 3
				if location_term_current_score < 1
					location_term_current_score = 1
				end
			end 

			#Assign uploader rank based on a scorce gived by users
			#puts video.author_name
			#uploader_rank = Author.find(:all, :author_name => video.author_name)
			#puts video.author_name
			begin
			uploader_rank = Author.where(:author_name => video.author_name).first
			if uploader_rank.trusted_uploader_rank == nil
				processed_uploader_rank = 1
			else
				processed_uploader_rank = uploader_rank.trusted_uploader_rank
			end
			#puts "processed_uploader_rank"
			#puts processed_uploader_rank
			rescue
				puts "error finding trusted_uploader_rank"
				processed_uploader_rank = 1
			end
			#if uploader_rank == nil
			#	puts "where the fuck is it"
			#else
			#	puts "uploader_rank.trusted_uploader_rank"
			#	puts uploader_rank.trusted_uploader_rank
			#end
			video.update_attributes(:geo_rank => geo_score, :search_terms_rank => title_score, :location_mention_rank => location_term_current_score, :trusted_uploader_rank => processed_uploader_rank)
		end
	end
end