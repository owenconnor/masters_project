 require 'rufus/scheduler'
 scheduler = Rufus::Scheduler.start_new

 scheduler.every '30s' do

    puts "Running Persistant Scheduled Searches!" 
    #Get all active searchs
    search = Search.where(:active_search => true)
    puts "Number of active searches: #{search.count}"
    #loop through them and send them to the sidekiq worker
    search.each do |individual_search|
    	puts "#{individual_search.id}"
	   	location_context_terms = YtSearchResult.get_location_search_terms(individual_search.id)
		#Get Search info from select search concept
	    combined_search_terms = YtSearchResult.get_combined_context_terms(individual_search.id)

	    translated_terms = YtSearchResult.translate_terms(combined_search_terms, individual_search.id)
	    
	    combined_search_terms |= translated_terms

	    puts "----------------------------------"
	    puts "Details for this active Search"
	    puts "#{individual_search.search_name}"
	    puts "#{individual_search.id}"
	    puts "#{location_context_terms}"
	    puts "#{combined_search_terms}"
	    puts "Latitude:#{individual_search.latitude}"
	    puts "Longitude:#{individual_search.longitude}"
	    puts "----------------------------------"
	    
	    #sent to a sidekiq worker
	    YoutubeSearchWorker.perform_async(location_context_terms,combined_search_terms, individual_search.id)
	end
	puts "Finished Rufus Scheduled Searches!"
end