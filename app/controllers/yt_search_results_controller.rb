class YtSearchResultsController < ApplicationController
  # GET /yt_search_results
  # GET /yt_search_results.json
  def index
    #Check if a sort option has been selected, otherwise show the new results
    if params.has_key?(:sort_by)
      case params[:sort_by]
        when "uploader"
          @sort_by = "author_name"
        when "published"
          @sort_by = "published"
        when "geo"
          @sort_by = "geo"
        when "ranking"
          # send to ranking
        else
          @sort_by = "notify_new"
        end
    end

    #check for search id param and return results based on that id
    if params.has_key?(:search_id)
      #Get correct search details and order by the requested sort option if it exists
      @yt_search_results = YtSearchResult.where(:search_id => params[:search_id]).order(@sort_by)
      #paginate pages using will_paginate gem
      if params[:page].blank? == true
        @yt_search_results = @yt_search_results.paginate(:page => 1, :per_page => 10)
      else
        @yt_search_results = @yt_search_results.paginate(:page => params[:page], :per_page => 10)
      end
      @notify_new = YtSearchResult.where(:search_id => params[:search_id], :notify_new => true)
      #Get id of current search to show as active in nav menu
      @current_search = params[:search_id].to_i
    else
      redirect_to searches_path notice: 'There is no search with that ID. Please select one from below.'
    end

    @new_results = YtSearchResult.where(:search_id => params[:search_id], :notify_new => true)
    
    @active_searches = Search.where(:active_search => true)

    @search = Search.find(@current_search)

    update_notifications = @notify_new
    logger.debug "notify_new: :#{@notify_new.count}"
    logger.debug "update_notifications: :#{update_notifications.count}"

    update_notifications.each do |update|
      update.update_attributes(:notify_new => false)
    end    


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
    @search = Search.find(params[:search_id])
    @location_context_terms = YtSearchResult.get_location_search_terms(@search.id)
    #logger.debug "location_context_terms (controller): #{@location_context_terms}"

    #Get Search info from select search concept
    @combined_search_terms = YtSearchResult.get_combined_context_terms(@search.id)
    #logger.debug "@combined_search_terms: #{@combined_search_terms}"

    @translated_terms = YtSearchResult.translate_terms(@combined_search_terms, @search.id)
    
    logger.debug "@translated_terms post model: #{@translated_terms}"
    
    @combined_search_terms |= @translated_terms

    logger.debug "translated + combined terms: #{@combined_search_terms}"

    @search.update_attributes(:active_search => true)

    YoutubeSearchWorker.perform_async(@location_context_terms, @combined_search_terms, @search.id)
          
    #YtSearchResult.generate_search_results(@location_context_terms, @combined_search_terms, @search.id)
              
    redirect_to yt_search_results_path(:search_id => @search.id)
  end
end
