class GenerateAhpRankingWorker
	include Sidekiq::Worker

	def perform
		#Eigen Values
		trusted_uploader_ratio = 0.5000
		location_mention_ratio = 0.2500
		search_term_ratio = 0.2500
		has_geolocatio_ratio = 0.1000

		all_active_searches = Search.where(:active_search => true)
		all_active_searches.each do |search|
			geo_sum = YtSearchResult.sum(:geo_rank, :conditions => {:search_id => search.id})
			search_terms_sum = YtSearchResult.sum(:search_terms_rank, :conditions => {:search_id => search.id})
			location_mention_sum = YtSearchResult.sum(:location_mention_rank, :conditions => {:search_id => search.id})
			trusted_uploader_sum = YtSearchResult.sum(:trusted_uploader_rank, :conditions => {:search_id => search.id})
			
			single_search_results = YtSearchResult.where(:search_id => search.id)
			single_search_results.each do |result|
				geo_score =(1/1)*has_geolocatio_ratio
				puts "Geo Score"
				puts geo_score*1000
				search_term_score =(result.search_terms_rank/search_terms_sum)*search_term_ratio
				puts "Search Score"
				puts search_term_score*1000
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