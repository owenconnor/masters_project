# encoding: utf-8
class YtSearchResult < ActiveRecord::Base
  	attr_accessible :author_name, :author_url, :category, :description, :duration, :embed_url, :geo, :id, :keywords, :player_url, :published, :search_id, :thumbnails, :title, :updated, :viewcount, :video_id, :thumbnails

    EasyTranslate.api_key = 'AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw'

  	def self.get_location_search_terms(search_id)
      search = Search.find(search_id)
	    location_context_terms = search.location + "," + search.vicinity
      location_context_terms.split(/[\s,]+/)
  	end

    def self.get_combined_context_terms(search_id)
      search = Search.find(search_id)
      predefined_terms = SearchConcept.find(search.search_concept_id).terms
      context_terms = Search.find(search.id).context_terms
      combined_search_terms = predefined_terms + "," + context_terms
      combined_search_terms.split(/[\s,]+/)
    end

    def self.translate_terms(terms, search_id)
        @second_lang = Search.find(search_id).second_language
        logger.debug "terms passed to model:#{terms}"
        translated_terms = Array.new
        terms.each do |term|
          translated_terms.push(EasyTranslate.translate(term, :to => :french))
        end
        logger.debug "translated_terms to be returned:#{translated_terms}"
        return translated_terms
        
    end

    def self.generate_search_results(location_terms, combined_terms, search_id)
    	#create array for storing each record returned
      search_result = Array.new
      compiled_search_results = Array.new

      #Iterate around Location terms
      location_terms.each do |location|
        combined_terms.each do |search_term|
          logger.debug "search_term: #{search_term}"
          search_terms_insert = location  + "," +  search_term 
          search_terms_insert.sub(",","%2C")
          search_terms_insert.sub(" ","%20")
          

          logger.debug "search_terms_insert #{search_terms_insert}"           
          search_result = HTTParty.get("https://gdata.youtube.com/feeds/api/videos?q=#{search_terms_insert}&time=this_week&max-results=10&key=AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw&alt=json")
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

    def self.process_search_results(search_results, search_id)
      logger.debug "process search result data count: #{search_results.count}"
      
      all_search_results = Array.new
      all_previous_videos_ids = YtSearchResult.select(:video_id).map {|v| v.video_id}

      search_results.each do |video_result| 
        #logger.debug "Video ID's in loop: #{video_result[i]["id"]["$t"]}"
        video_id =  video_result["id"]["$t"].delete("http://gdata.youtube.com/feeds/api/videos/")
          logger.debug "Parsing video_id: #{video_id}" 
        published = video_result["published"]["$t"]
          #logger.debug "published #{published}" 
        updated = video_result["updated"]["$t"]
          #logger.debug "updated #{updated}"
        embed_url = video_result["link"][0]["href"]
          #logger.debug "embed_url #{embed_url}"
        author_name = video_result["author"][0]["name"]["$t"]
          #logger.debug "author_name #{author_name}"
        author_url = video_result["author"][0]["uri"]["$t"]
          #logger.debug "author_url #{author_url}"
        category = video_result["media$group"]["media$category"][0]["label"]
          #logger.debug "category #{category}"
        description = video_result["media$group"]["media$description"]["$t"]
          #logger.debug "description #{description}"
        keywords = video_result["media$group"]["media$keywords"]
          #logger.debug "keywords #{keywords}"
        player_url = video_result["media$group"]["media$player"][0]["url"]
          #logger.debug "player_url #{player_url}"
        thumbnails = video_result["media$group"]["media$thumbnail"][0]["url"]
          #logger.debug "thumbnails #{thumbnails}"
        title = video_result["media$group"]["media$title"]["$t"]
          #logger.debug "title #{title}"
        duration = video_result["media$group"]["yt$duration"]["seconds"]
          #logger.debug "duration #{duration}"
        #if video_result["yt$statistics"]["viewCount"] == nil
        #  viewcount = "0"
        #else
          #viewcount = video_result["yt$statistics"]["viewCount"]
        #end
        #  logger.debug "viewcount #{viewcount}"
        #geo = video_result["georss$where"]["gml$Point"]["gml$pos"]["$t"]
          #logger.debug "geo #{geo}"
       
            
        #put individual results in an array
        single_search_data = Array.new
        single_search_data.push(
          video_id, 
          published,  
          updated, 
          embed_url,
          author_name, 
          author_url,
          category,  
          description,
          keywords, 
          player_url, 
          thumbnails, 
          title, 
          duration,
          search_id,
          #viewcount 
          #geo
          )

        #logger.debug "single_search_data: #{single_search_data}"
        
        old_video = all_previous_videos_ids.include?(video_id)
        logger.debug "Old Video?: #{old_video}"

        #add to array if video_id is not in DB
        if old_video == false 
          all_search_results.push(single_search_data)
          logger.debug "Result not a dupe"
        else
          logger.debug "Duplicate found and not added"
        end
        #Add all results to a nested array
        
        

      end
        logger.debug "All Results: #{all_search_results.count}"
        #YtSearchResult.write_results_to_db(all_search_results)

        logger.debug "Results to write to DB: #{all_search_results.count}"
        all_search_results.each do |result|
          logger.debug "Result: #{result[1]}"
          begin           
            yt_search_results = YtSearchResult.new
            #logger.debug "Result#{result[0]}"
            yt_search_results.update_attributes(
                #:id => result[0],
                :video_id => result[0],
                :published => result[1],
                :updated => result[2], 
                :embed_url =>result[3],
                :author_name => result[4], 
                :author_url => result[5],
                :category => result[6], 
                :description => result[7],
                :keywords => result[8], 
                :player_url => result[9], 
                :thumbnails => result[10], 
                :title => result[11], 
                :duration => result[12],
                :search_id => result[13], 
                #:viewcount => result[14] 
                #:geo => "01",
              )
          rescue
            logger.debug "SQL insert failed at #{result}"  
          end            
        end  

    end

    def self.write_results_to_db(search_results)
      
    end
  end

