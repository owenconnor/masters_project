# encoding: utf-8
class YtSearchResult < ActiveRecord::Base
    belongs_to :author
  	attr_accessible :author_name, :author_url, :category, :description, :duration, :embed_url, :geo, :id, :keywords, :player_url, :published, :search_id, :thumbnails, :title, :updated, :viewcount, :video_id, :notify_new,:geo_rank, :search_terms_rank, :location_mention_rank, :trusted_uploader_rank
    EasyTranslate.api_key = 'AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw'
    #self.per_page = 10


  	def self.get_location_search_terms(search_id)
      search = Search.find(search_id)
	    location_context_terms = search.location #+ "," + search.vicinity
      location_context_terms.split(/[\s,]+/)
  	end

    def self.get_combined_context_terms(search_id)
      search = Search.find(search_id)
      predefined_terms = SearchConcept.find(search.search_concept_id).terms
      context_terms = Search.find(search.id).context_terms
      if context_terms == nil
        combined_search_terms = predefined_terms
        combined_search_terms.split(/[\s,]+/)
      else
        combined_search_terms = predefined_terms + "," + context_terms
        combined_search_terms.split(/[\s,]+/)
      end
    end

    def self.translate_terms(terms, search_id)
        @second_lang = "arabic"#Search.find(search_id).second_language
        logger.debug "terms passed to model:#{terms}"
        translated_terms = Array.new
        terms.each do |term|
          translated_terms.push(EasyTranslate.translate(term, :to => @second_lang)) #@second_lang.to_sym
        end
        logger.debug "translated_terms to be returned:#{translated_terms}"
        return translated_terms
        
    end

    #def self.generate_search_results(location_terms, combined_terms, search_id)
  	#end

    def self.process_search_results(search_results, search_id)
      logger.debug "process search result data count: #{search_results.count}"
      
      all_search_results = Array.new
      all_previous_videos_ids = YtSearchResult.select(:video_id).map {|v| v.video_id}
      all_previous_authors = Author.select(:author_url).map {|a| a.author_url}
      logger.debug "all_previous_authors: #{all_previous_authors}"

      search_results.each do |video_result| 
        #logger.debug "Video ID's in loop: #{video_result[i]["id"]["$t"]}"
        video_id =  video_result["id"]["$t"].gsub("http://gdata.youtube.com/feeds/api/videos/", "")
          logger.debug "Parsing video_id: #{video_id}" 
        published = video_result["published"]["$t"]
          #logger.debug "published #{published}" 
        updated = video_result["updated"]["$t"]
          #logger.debug "updated #{updated}"
        embed_url = video_result["link"][0]["href"].gsub("&feature=youtube_gdata_player", "")
          #logger.debug "embed_url #{embed_url}"
        author_name = video_result["author"][0]["name"]["$t"]
          #logger.debug "author_name #{author_name}"
        author_url = video_result["author"][0]["uri"]["$t"].gsub("https://gdata.youtube.com/feeds/api/users/", "https://www.youtube.com/user/")
          #logger.debug "author_url #{author_url}"
        category = video_result["media$group"]["media$category"][0]["label"]
          #logger.debug "category #{category}"
        description = video_result["media$group"]["media$description"]["$t"]
          #logger.debug "description #{description}"
        keywords = video_result["media$group"]["media$keywords"]
          #logger.debug "keywords #{keywords}"
        player_url = video_result["media$group"]["media$player"][0]["url"].gsub("&feature=youtube_gdata_player", "")
          #logger.debug "player_url #{player_url}"
        thumbnails = video_result["media$group"]["media$thumbnail"][0]["url"]
          #logger.debug "thumbnails #{thumbnails}"
        title = video_result["media$group"]["media$title"]["$t"]
          #logger.debug "title #{title}"
        duration = video_result["media$group"]["yt$duration"]["seconds"]
          #logger.debug "duration #{duration}"
        if video_result.keys.include? "viewCount"
          if video_result["yt$statistics"]["viewCount"] != nil
              viewcount = video_result["yt$statistics"]["viewCount"]
          end
        else
          viewcount = nil
        end
          logger.debug "viewcount #{viewcount}"
        if video_result.keys.include? "georss$where"
          geo = video_result["georss$where"]["gml$Point"]["gml$pos"]["$t"]
          logger.debug "geo #{geo}"
        else
          geo = "No Geolocation"
          logger.debug "geo #{geo}"
        end

        #append embed code to embed url
        embed_url = ActiveSupport::SafeBuffer.new('<iframe width="480" height="270" src="https://www.youtube.com/embed/'+ video_id + '?frameborder="0"allowfullscreen"></iframe>')
        logger.debug "embed_url: #{embed_url}"

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
          viewcount, 
          geo
          )
        #dedupe against videos already in db
        old_video = all_previous_videos_ids.include?(video_id)
        logger.debug "Old Video?: #{old_video}"

        #add to array if video_id is not in DB
        if old_video == false 
          all_search_results.push(single_search_data)
          logger.debug "Result not a dupe"
        else
          logger.debug "Duplicate video found and not added"
        end

        #dedupe against authors already in db
        existing_author = all_previous_authors.include?(author_url)
        logger.debug "existing_author?: #{existing_author}"
        if existing_author == false
          author =  Author.new
          author.update_attributes(:author_name => author_name, :author_url => author_url) 
          logger.debug "Author is not a dupe"
        else
          logger.debug "Duplicate author found and not added"
        end
      end
        logger.debug "All Results: #{all_search_results.count}"
        #YtSearchResult.write_results_to_db(all_search_results)
        result_test = all_search_results[0]
        logger.debug "Result15: #{result_test}"
        logger.debug "Results to write to DB: #{all_search_results.count}"
        all_search_results.each do |result|
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
                :notify_new => true, 
                :viewcount => result[14], 
                :geo => result[15]
              )
          rescue
            logger.debug "SQL insert failed at #{result}"  
          end 
        end  
        all_searches = Search.all
        logger.debug "all_searches #{all_searches}"  
        all_searches.each do |notify_search|
          notification_count = YtSearchResult.where(:notify_new => true, :search_id => notify_search.id).count
          logger.debug "notify_search.id #{notify_search.id}"
          logger.debug "notification_count #{notification_count}"  
          notify_search.update_attributes(:notification_count => notification_count)
        end
    end
end

