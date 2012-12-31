class YoutubeSearchWorker
	include Sidekiq::Worker

	def perform(location_terms, combined_terms, search_id)
		logger.debug "Starting Search for id: #{search_id}"
		#create array for storing each record returned
	    search_result = Array.new
	    compiled_search_results = Array.new
	    search = Search.find(search_id)

	    if search.date_range = "This Week"
	    	date_range = "this_week"
	    elsif search.date_range = "This Month"
	        date_range = "this_month"
	    else
	        date_range = "today"
	    end

	    #Iterate around terms without geolocation
	    logger.debug "Location terms: #{location_terms}"
	    location_terms.each do |location|
	    	combined_terms.each do |search_term|
	        	logger.debug "search_term: #{search_term}"
	        	search_terms_insert = location  + "," +  search_term 
	        	search_terms_insert.sub(",","%2C")
	        	search_terms_insert.sub(" ","%20")
	          
	        	search_terms_insert_escaped = CGI::escape(search_terms_insert)
	          	logger.debug "search_terms_insert #{search_terms_insert}"           
	          	search_result = HTTParty.get("https://gdata.youtube.com/feeds/api/videos?q=#{search_terms_insert_escaped}&time=#{date_range}&max-results=10&key=AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw&alt=json")
	          	
	          	if search_result["feed"]["entry"] == nil 
	            	next
	          	end
	          	search_result["feed"]["entry"].each do |entry|
	          		#logger.debug "entry: #{entry}"
	          		compiled_search_results.push(entry)
	        	end
	        	logger.debug "compiled_search_results.count: #{compiled_search_results.count}"         
	    	end
	    end

	    #get geo coordinates
	    search_coordinates = search.latitude.to_s + "," + search.longitude.to_s
	    search_radius = "100"


	    #Iterate around terms with geolocation
	    logger.debug "Location terms: #{location_terms}"
	    location_terms.each do |location|
	    	combined_terms.each do |search_term|
	        	logger.debug "search_term: #{search_term}"
	        	search_terms_insert = location  + "," +  search_term 
	        	search_terms_insert.sub(",","%2C")
	        	search_terms_insert.sub(" ","%20")
	          
	        	search_terms_insert_escaped = CGI::escape(search_terms_insert)
	          	logger.debug "search_terms_insert #{search_terms_insert}"           
	          	search_result_location = HTTParty.get("https://gdata.youtube.com/feeds/api/videos?q=#{search_terms_insert_escaped}&time=#{date_range}&location=#{search_coordinates}&location-radius=#{search_radius}km&max-results=10&key=AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw&alt=json")
	          	
	          	if search_result["feed"]["entry"] == nil 
	            	next
	          	end
	          	search_result["feed"]["entry"].each do |entry|
	          		#logger.debug "entry: #{entry}"
	          		compiled_search_results.push(entry)
	        	end
	        	logger.debug "compiled_search_results.count: #{compiled_search_results.count}"         
	    	end
	    	compiled_search_results = compiled_search_results.uniq
	    	YtSearchResult.process_search_results(compiled_search_results, search_id)
	    end	
	end
end