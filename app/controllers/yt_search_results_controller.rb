class YtSearchResultsController < ApplicationController
  # GET /yt_search_results
  # GET /yt_search_results.json
  def index
    @yt_search_results = YtSearchResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @yt_search_results }
    end
  end

  # GET /yt_search_results/1
  # GET /yt_search_results/1.json
  def show
    @yt_search_result = YtSearchResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @yt_search_result }
    end
  end

  # GET /yt_search_results/new
  # GET /yt_search_results/new.json
  def new
    @yt_search_result = YtSearchResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @yt_search_result }
    end
  end

  # GET /yt_search_results/1/edit
  def edit
    @yt_search_result = YtSearchResult.find(params[:id])
  end

  # POST /yt_search_results
  # POST /yt_search_results.json
  def create
    @yt_search_result = YtSearchResult.new(params[:yt_search_result])

    respond_to do |format|
      if @yt_search_result.save
        format.html { redirect_to @yt_search_result, notice: 'Yt search result was successfully created.' }
        format.json { render json: @yt_search_result, status: :created, location: @yt_search_result }
      else
        format.html { render action: "new" }
        format.json { render json: @yt_search_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /yt_search_results/1
  # PUT /yt_search_results/1.json
  def update
    @yt_search_result = YtSearchResult.find(params[:id])

    respond_to do |format|
      if @yt_search_result.update_attributes(params[:yt_search_result])
        format.html { redirect_to @yt_search_result, notice: 'Yt search result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @yt_search_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yt_search_results/1
  # DELETE /yt_search_results/1.json
  def destroy
    @yt_search_result = YtSearchResult.find(params[:id])
    @yt_search_result.destroy

    respond_to do |format|
      format.html { redirect_to yt_search_results_url }
      format.json { head :no_content }
    end
  end

  def youtube_search
    @terms = SearchConcept.find(params[:id]).terms
    @search_concept_name = SearchConcept.find(params[:id]).name
    @search_concept_ancestors = SearchConcept.find(params[:id]).ancestors
    logger.debug "@ancestors: #{@search_concept_ancestors}"
    #extract node names useful to search
    @ancestor_search_terms = Array.new
    @search_concept_ancestors.each do |ancestor|
      if ancestor.navigation_node == false
        @ancestor_search_terms.push(ancestor.name)
      end
    end
    logger.debug "@ancestor_search_terms: #{@ancestor_search_terms}"
    
    #capture search concept passed in
    @search_concept_id = params[:id]
    
    #split search terms into single terms
    @indiviual_terms_array = @terms.split
    logger.debug "indiviual terms: #{@indiviual_terms_array}"

    #See how many terms there are to interate searches for
    @term_count = @indiviual_terms_array.count
    logger.debug "term count: #{@term_count}"
    
    #create array for storing each record returned
    @search_result = Array.new

    #Iterate around ancestor terms
    @ancestor_search_terms.each do |ancestor_term|
      #Iterate around required search terms and do search for each
      @i=0
      @indiviual_terms_array.each do |search_term|
        #@search_terms = search_term.chop + "%2C" + @search_concept_name
        search_terms_insert = ancestor_term+ "%2C" + search_term 
        search_terms_insert = search_terms_insert.sub(",","%2C")
        logger.debug "ancestor_term_loop #{ancestor_term}"
        logger.debug "search_term_loop #{search_term}"
        logger.debug "search_terms_insert #{search_terms_insert}"
        @search_result[@i] = HTTParty.get("https://gdata.youtube.com/feeds/api/videos?q=#{search_terms_insert}&time=this_week&max-results=50&key=AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw&alt=json")
        @i = @i+1          
      end
    end
    #logger.debug "@search_result[@i] #{@search_result[0]}"
    #array for collecting all results later in code
    @all_search_results = Array.new
    #used to ensure video is no already in db later
    @all_previous_videos_ids = YtSearchResult.select(:video_id).map {|v| v.video_id}

    #Write results to the database
      y = 0
      while y < @term_count do
        #logger.debug "term count: #{@term_count}"
            @search_result[y]["feed"]["entry"].each do |video_result| 
              video_id =  video_result["id"]["$t"].delete("http://gdata.youtube.com/feeds/api/videos/")
              logger.debug "#{video_id}" 
              published = video_result["published"]["$t"]
              logger.debug "published #{published}" 
              updated = video_result["updated"]["$t"]
              logger.debug "updated #{updated}"
              embed_url = video_result["link"][0]["href"]
              logger.debug "embed_url #{embed_url}"
              author_name = video_result["author"][0]["name"]["$t"]
              logger.debug "author_name #{author_name}"
              author_url = video_result["author"][0]["uri"]["$t"]
              logger.debug "author_url #{author_url}"
              category = video_result["media$group"]["media$category"][0]["label"]
              logger.debug "category #{category}"
              description = video_result["media$group"]["media$description"]["$t"]
              logger.debug "description #{description}"
              keywords = video_result["media$group"]["media$keywords"]
              logger.debug "keywords #{keywords}"
              player_url = video_result["media$group"]["media$player"][0]["url"]
              logger.debug "player_url #{player_url}"
              thumbnails = video_result["media$group"]["media$thumbnail"][0]["url"]
              logger.debug "thumbnails #{thumbnails}"
              title = video_result["media$group"]["media$title"]["$t"]
              logger.debug "title #{title}"
              duration = video_result["media$group"]["yt$duration"]["seconds"]
              logger.debug "duration #{duration}"
              #if video_result["yt$statistics"]["viewCount"] == nil
              #  viewcount = 0
              #else
              #  viewcount = video_result["yt$statistics"]["viewCount"]
              #end
              #logger.debug "viewcount #{viewcount}"
              #geo = video_result["georss$where"]["gml$Point"]["gml$pos"]["$t"]
              #logger.debug "geo #{geo}"

              #put individual results in an array
              @single_search_data = Array.new
              @single_search_data.push(
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
                @search_concept_id,
                #viewcount 
                #geo
                )
              
              #check video id is not already in DB  
              old_video = @all_previous_videos_ids.include?(video_id)
              logger.debug "Old Video?: #{old_video}"

              #add to array if video_id is not in DB
              if old_video == false
                #Add all results to a nested array
                @all_search_results.push(@single_search_data)
                logger.debug "All Results: #{@all_search_results.count}" 
                #dedupe array before trying to write to DB
                @all_search_results = @all_search_results.uniq
              end
            end
          y = y + 1      
        end
        
        logger.debug "Result Count: #{@all_search_results.count}"
        @all_search_results.each do |result|
          begin           
            @yt_search_results = YtSearchResult.new
            logger.debug "Result#{result[0]}"
             @yt_search_results.update_attributes(
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
            logger.debug "SQL insert failed at #{result[0]}"  
          end            
        end
      #redirect_to yt_search_results_url
  end

end
