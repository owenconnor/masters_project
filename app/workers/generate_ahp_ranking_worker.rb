class GenerateAhpRankingWorker
	include Sidekiq::Worker

	def perform
		#Eigen Values derived from journalists judgments
		trusted_uploader_ratio = 0.5000
		location_mention_ratio = 0.2500
		search_term_ratio = 0.2500
		has_geolocation_ratio = 0.1000

		#Get all the active searches in order to update ranking
		all_active_searches = Search.where(:active_search => true)
		#Iterate througn records and evaluate AHP scorce based on other rankings.
		all_active_searches.each do |search|
			geo_sum = YtSearchResult.sum(:geo_rank, :conditions => {:search_id => search.id})
			search_terms_sum = YtSearchResult.sum(:search_terms_rank, :conditions => {:search_id => search.id})
			location_mention_sum = YtSearchResult.sum(:location_mention_rank, :conditions => {:search_id => search.id})
			trusted_uploader_sum = YtSearchResult.sum(:trusted_uploader_rank, :conditions => {:search_id => search.id})
			
			single_search_results = YtSearchResult.where(:search_id => search.id)
			single_search_results.each do |result|
				geo_score = (1/1)*has_geolocation_ratio
				#if geo_score != nil
				#	puts "Geo Score"
				#	puts geo_score*1000
				#end
				search_term_score =(result.search_terms_rank/search_terms_sum)*search_term_ratio
				#search_term_score =(1/1)*search_term_ratio
				#if search_term_score != nil
				#	puts "Search Score"
				#	puts search_term_score*1000
				#end
				#location_mention_score =(1/1)*location_mention_ratio
				location_mention_score =(result.location_mention_rank/location_mention_sum)*location_mention_ratio
				#if location_mention_score != nil
				#	puts "location Score"
				#	puts location_mention_score*1000
				#end
				#trusted_uploader_score =(1/1)*trusted_uploader_ratio
				trusted_uploader_score =(result.trusted_uploader_rank/trusted_uploader_sum)*trusted_uploader_ratio
				#if trusted_uploader_score != nil
				#	puts "trusted uploader score"
				#	puts trusted_uploader_score*1000
				#end

				#total the scores for the ahp score
				ahp_ranking_score = geo_score + search_term_score + location_mention_score + trusted_uploader_score
				#puts "ahp_ranking_score"
				#puts ahp_ranking_score
				#write score to the db
				result.update_attributes(:ahp_rank => ahp_ranking_score)

			end
		end


		
		#puts "AHP geo_sum"
		#puts geo_sum
		#puts "AHP search_terms_sum"
		#puts search_terms_sum
		#puts "AHP location_mention_sum"
		#puts location_mention_sum
		#puts "AHP trusted_uploader_sum"
		#puts trusted_uploader_sum
	end
end